defmodule LogsWebhookWeb.FallbackController do
  use LogsWebhookWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(LogsWebhookWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
