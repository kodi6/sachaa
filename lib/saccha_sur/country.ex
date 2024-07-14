defmodule SacchaSur.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :name, :string
    field :country_id, :string
    field :phone_code, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:country_id, :name, :phone_code])
    |> validate_required([:country_id, :name, :phone_code])
  end
end
