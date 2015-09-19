defmodule Ws.GlobalChannel do
  use Phoenix.Channel

  def join("global:pomodoro_event", payload, socket) do
    {:ok, socket}
  end

  def handle_in("pomodoro_start", payload, socket) do
    broadcast socket, "pomodoro_start", socket.assigns
    {:noreply, socket}
  end
end
