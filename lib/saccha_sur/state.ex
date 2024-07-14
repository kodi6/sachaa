defmodule SacchaSur.State do
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :name, :string
    field :state_id, :string
    field :country_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:state_id, :name, :country_id])
    |> validate_required([:state_id, :name, :country_id])
  end
end
