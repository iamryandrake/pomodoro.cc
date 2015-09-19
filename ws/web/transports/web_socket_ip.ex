defmodule Ws.Transports.WebSocketIp do
  @behaviour Phoenix.Socket.Transport

  def default_config() do
    [serializer: Phoenix.Transports.WebSocketSerializer,
     timeout: :infinity,
     transport_log: false,
     heartbeat: 30_000]
  end

  def handlers() do
    %{cowboy: Phoenix.Endpoint.CowboyWebSocket}
  end

  ## Callbacks

  import Plug.Conn

  alias Phoenix.Socket.Broadcast
  alias Phoenix.Socket.Transport
  alias Phoenix.Socket.Message
  @doc false
  def init(%Plug.Conn{method: "GET"} = conn, {endpoint, handler, transport}) do
    {_, opts} = handler.__transport__(transport)

    conn =
      conn
      |> Plug.Conn.fetch_query_params
      |> Transport.transport_log(opts[:transport_log])
      |> Transport.force_ssl(handler, endpoint, opts)
      |> Transport.check_origin(handler, endpoint, opts)

    case conn do
      %{halted: false} = conn ->
        params     = conn.params
        serializer = Keyword.fetch!(opts, :serializer)

        case Transport.connect(endpoint, handler, transport, __MODULE__, serializer, params) do
          {:ok, socket} ->
            ip = conn_ip(conn)

            socket = Phoenix.Socket.assign(socket, :ip, ip)
            socket = ip_to_geo(ip)
              |> decode_geo
              |> assign_location_to(socket)

            {:ok, conn, {__MODULE__, {socket, opts}}}
          :error ->
            send_resp(conn, 403, "")
            {:error, conn}
        end
      %{halted: true} = conn ->
        {:error, conn}
    end
  end

  defp conn_ip(conn) do
    ip_header = List.keyfind(conn.req_headers, "x-real-ip", 0)
    elem(ip_header, 1)
  end

  defp ip_to_geo(ip) do
    HTTPoison.get!("https://freegeoip.net/json/#{ip}")
  end

  defp decode_geo(response) do
    Poison.decode(response.body)
  end

  defp assign_location_to({:ok, body}, socket) do
    latitude = Dict.get(body, "latitude", "")
    longitude = Dict.get(body, "longitude", "")
    socket = Phoenix.Socket.assign(socket, :latitude, latitude)
    socket = Phoenix.Socket.assign(socket, :longitude, longitude)
    socket
  end

  def init(conn, _) do
    send_resp(conn, :bad_request, "")
    {:error, conn}
  end

  @doc false
  def ws_init({socket, config}) do
    Process.flag(:trap_exit, true)
    serializer = Keyword.fetch!(config, :serializer)
    timeout    = Keyword.fetch!(config, :timeout)
    heartbeat  = Keyword.fetch!(config, :heartbeat)

    if socket.id, do: socket.endpoint.subscribe(self, socket.id, link: true)

    :timer.send_interval(heartbeat, :phoenix_heartbeat)

     {:ok, %{socket: socket,
          channels: HashDict.new,
          channels_inverse: HashDict.new,
          client_last_active: now_ms(),
          heartbeat_interval: heartbeat,
          serializer: serializer}, timeout}
  end

  @doc false
  def ws_handle(opcode, payload, state) do
    msg   = state.serializer.decode!(payload, opcode: opcode)
    state = bump_client_last_active(state)

    case Transport.dispatch(msg, state.channels, state.socket) do
      :noreply ->
        {:ok, state}
      {:reply, reply_msg} ->
        encode_reply(reply_msg, state)
      {:joined, channel_pid, reply_msg} ->
        encode_reply(reply_msg, put(state, msg.topic, channel_pid))
      {:error, _reason, error_reply_msg} ->
        encode_reply(error_reply_msg, state)
    end
  end

  @doc false
  def ws_info({:EXIT, channel_pid, reason}, state) do
    case HashDict.get(state.channels_inverse, channel_pid) do
      nil   -> {:ok, state}
      topic ->
        new_state = delete(state, topic, channel_pid)
        encode_reply Transport.on_exit_message(topic, reason), new_state
    end
  end

  @doc false
  def ws_info(%Broadcast{event: "disconnect"}, state) do
    {:shutdown, state}
  end

  def ws_info({:socket_push, _, _encoded_payload} = msg, state) do
    format_reply(msg, state)
  end

  def ws_info(:phoenix_heartbeat, state) do
    if client_unresponsive?(state) do
      {:shutdown, state}
    else
      encode_reply heartbeat_message(), state
    end
  end

  def ws_info(_, state) do
    {:ok, state}
  end

  defp client_unresponsive?(state) do
    now_ms() - state.client_last_active > (state.heartbeat_interval * 2)
  end

  @doc false
  def ws_terminate(_reason, _state) do
    :ok
  end

  @doc false
  def ws_close(state) do
    for {pid, _} <- state.channels_inverse do
      Phoenix.Channel.Server.close(pid)
    end
  end

  defp put(state, topic, channel_pid) do
    %{state | channels: HashDict.put(state.channels, topic, channel_pid),
              channels_inverse: HashDict.put(state.channels_inverse, channel_pid, topic)}
  end

  defp delete(state, topic, channel_pid) do
    %{state | channels: HashDict.delete(state.channels, topic),
              channels_inverse: HashDict.delete(state.channels_inverse, channel_pid)}
  end

  defp encode_reply(reply, state) do
    format_reply(state.serializer.encode!(reply), state)
  end

  defp format_reply({:socket_push, encoding, encoded_payload}, state) do
    {:reply, {encoding, encoded_payload}, state}
  end

  defp bump_client_last_active(state) do
    %{state | client_last_active: now_ms()}
  end

  # from Phoenix.Utils
  def now_ms, do: :os.timestamp() |> time_to_ms()
  defp time_to_ms({mega, sec, micro}) do
    trunc(((mega * 1000000 + sec) * 1000) + (micro / 1000))
  end

  # from Phoenix.Transport
  def heartbeat_message() do
    %Message{topic: "phoenix", event: "heartbeat", payload: %{}}
  end
end
