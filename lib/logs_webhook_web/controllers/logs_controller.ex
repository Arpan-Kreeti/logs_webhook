defmodule LogsWebhookWeb.LogsController do
  use LogsWebhookWeb, :controller
  alias LogsWebhook.Logs

  action_fallback LogsWebhookWeb.FallbackController

  def create(conn, payload) do
    with {:ok, _} <- Logs.create_log(payload) do
      conn
      |> Plug.Conn.put_status(200)
      |> json(%{})
    end
  end
end
