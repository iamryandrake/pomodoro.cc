defmodule Ws.GlobalChannel do
  use Phoenix.Channel

  def join("global:pomodoro_event", payload, socket) do
    ip = Dict.get(socket.assigns, :ip, "")
    IO.puts "-- connection from #{ip}"
    {:ok, socket}
  end

  def handle_in("pomodoro_start", payload, socket) do
    broadcast socket, "pomodoro_start", payload
    {:noreply, socket}
  end
end
