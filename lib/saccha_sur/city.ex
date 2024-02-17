defmodule SacchaSur.City do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cities" do
    field :name, :string
    field :city_id, :string
    field :state_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:city_id, :name, :state_id])
    |> validate_required([:city_id, :name, :state_id])
  end
end
