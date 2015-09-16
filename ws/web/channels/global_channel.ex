defmodule Ws.GlobalChannel do
  use Phoenix.Channel

  def join("global:pomodoro_event", payload, socket) do
    IO.puts "-- joining global:pomodoro_event"
    {:ok, socket}
  end

  def handle_in("pomodoro_start", payload, socket) do
    broadcast socket, "pomodoro_start", payload
    IO.puts "-- handling pomodoro_start"
    {:noreply, socket}
  end
end
