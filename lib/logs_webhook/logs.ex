defmodule LogsWebhook.Logs do
  alias LogsWebhook.{Repo, Logs.Log}
  import Ecto.Query

  def create_log(payload) do
    payload
    |> Log.changeset()
    |> Repo.insert()
  end

  def get_logs(params \\ %{}) do
    from(l in Log, order_by: [desc: :inserted_at])
    |> Repo.paginate(params)
  end
end
