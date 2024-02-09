defmodule SacchaSur.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkouts" do
    field :name, :string
    field :phone, :string
    field :email, :string
    field :shipping_address, :string
    field :house_number, :string
    field :state, :string
    field :city, :string
    field :country, :string
    field :postal_code, :string
    field :book_count, :string
    field :shipping_charge, :string
    field :total_amount, :decimal
    field :order_id, :string
    field :razorpay_payment_id, :string
    field :razorpay_signature, :string





    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:name, :phone, :email, :shipping_address, :house_number, :state, :city, :country, :postal_code, :book_count, :shipping_charge, :total_amount, :order_id, :razorpay_payment_id, :razorpay_signature])
    |> validate_required([:name, :phone, :email, :shipping_address, :house_number, :state, :city, :country, :postal_code, :book_count, :shipping_charge, :total_amount, :order_id])
  end
end
