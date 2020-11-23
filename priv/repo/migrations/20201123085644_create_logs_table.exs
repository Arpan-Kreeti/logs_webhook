defmodule LogsWebhook.Repo.Migrations.CreateLogsTable do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :payload, :string, null: false

      timestamps()
    end
  end
end
