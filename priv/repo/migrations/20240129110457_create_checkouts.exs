defmodule SacchaSur.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :name, :string
      add :amount, :decimal
      add :order_id, :string
      add :email, :string

      timestamps(type: :utc_datetime)
    end
  end
end
