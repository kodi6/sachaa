defmodule SacchaSur.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkouts" do
    field :name, :string
    field :amount, :decimal
    field :order_id, :string
    field :email, :string


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:name, :amount, :order_id, :email])
    |> validate_required([:name, :amount, :order_id, :email])
  end
end
