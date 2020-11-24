defmodule LogsWebhook.Logs do
  alias LogsWebhook.{Repo, Logs.Log}
  import Ecto.Query

  def create_log(payload) do
    payload
    |> Log.changeset()
    |> Repo.insert()
  end

  def get_logs(params \\ %{}) do
    Log
    |> search_query(params)
    |> filter_date(params)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
  end

  def search_query(query, %{"query" => search_term}) do
    from log in query,
      where: ilike(log.payload, ^"%#{search_term}%")
  end

  def search_query(query, _search_query), do: query

  def filter_date(query, %{"from" => start_date, "to" => end_date}) do
    from log in query,
      where: log.inserted_at >= ^start_date and log.inserted_at <= ^end_date
  end

  def filter_date(query, _date_range), do: query
end
