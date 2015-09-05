defmodule Ws.Endpoint do
  use Phoenix.Endpoint, otp_app: :ws

  socket "/socket", Ws.Socket

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.MethodOverride
  plug Plug.Head

  plug Ws.Router
end
