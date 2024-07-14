defmodule SacchaSur.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :city_id, :string
      add :name, :string
      add :state_id, :string

      timestamps(type: :utc_datetime)
    end
  end
end
