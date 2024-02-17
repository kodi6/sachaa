defmodule SacchaSur.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :state_id, :string
      add :name, :string
      add :country_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
