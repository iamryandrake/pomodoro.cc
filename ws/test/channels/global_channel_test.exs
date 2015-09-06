defmodule Ws.GlobalChannelTest do
  use Ws.ChannelCase

  alias Ws.GlobalChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(GlobalChannel, "global:pomodoro_event")

    {:ok, socket: socket}
  end

  test "shout broadcasts to global:pomodoro_event", %{socket: socket} do
    push socket, "pomodoro_start", %{"hello" => "all"}
    assert_broadcast "pomodoro_start", %{"hello" => "all"}
  end

end
