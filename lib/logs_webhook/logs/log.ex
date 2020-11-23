defmodule LogsWebhook.Logs.Log do
  use Ecto.Schema

  import Ecto.Changeset

  alias LogsWebhook.Logs.Log

  schema "logs" do
    field :payload, :string

    timestamps()
  end

  def changeset(attrs) do
    %Log{}
    |> cast(attrs, [:payload])
    |> validate_required([:payload])
  end
end
