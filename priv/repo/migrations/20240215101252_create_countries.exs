defmodule SacchaSur.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :country_id, :string
      add :name, :string
      add :phone_code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
