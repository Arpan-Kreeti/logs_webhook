defmodule LogsWebhook.Repo.Migrations.CreateLogsTable do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :payload, :text, null: false

      timestamps()
    end
  end
end
