defmodule LogsWebhook.Repo do
  use Ecto.Repo,
    otp_app: :logs_webhook,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
