defmodule LogsWebhookWeb.LogsController do
  use LogsWebhookWeb, :controller
  alias LogsWebhook.Logs

  action_fallback LogsWebhookWeb.FallbackController

  def create(conn, params) do
    with {:ok, _} <- Logs.create_log(%{payload: Jason.encode!(params)}) do
      conn
      |> Plug.Conn.put_status(200)
      |> json(%{})
    end
  end
end
