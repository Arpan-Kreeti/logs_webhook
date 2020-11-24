defmodule LogsWebhookWeb.LogsController do
  use LogsWebhookWeb, :controller
  alias LogsWebhook.Logs

  action_fallback LogsWebhookWeb.FallbackController
  @live_logs_topic "live_logs_topic"

  def create(conn, params) do
    with {:ok, _} <- Logs.create_log(%{payload: Jason.encode!(params)}) do
      LogsWebhookWeb.Endpoint.broadcast(@live_logs_topic, "new_log", %{})

      conn
      |> Plug.Conn.put_status(200)
      |> json(%{})
    end
  end
end
