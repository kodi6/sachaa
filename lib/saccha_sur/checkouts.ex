defmodule SacchaSur.Checkouts do
  alias SacchaSur.Checkout


  import Ecto.Query, warn: false
  alias SacchaSur.Repo


  alias SacchaSur.Checkout

  def create_checkout(attrs \\ %{}) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert()
  end

  def change_checkout(%Checkout{} = checkout, attrs \\ %{}) do
    Checkout.changeset(checkout, attrs)
  end

  def get_checkout_by_order(order_id) do
    Repo.get_by(Checkout, order_id: order_id)
  end
end
