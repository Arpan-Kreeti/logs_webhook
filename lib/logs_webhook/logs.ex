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

  def filter_date(query, %{"date_range" => ""}), do: query

  def filter_date(query, %{"date_range" => date_range}) do
    [start_date, end_date] = String.split(date_range, " - ")

    start_date = NaiveDateTime.from_iso8601!(start_date)
    end_date = NaiveDateTime.from_iso8601!(end_date)

    from log in query,
      where: log.inserted_at >= ^start_date and log.inserted_at <= ^end_date
  end

  def filter_date(query, _date_range), do: query
end
