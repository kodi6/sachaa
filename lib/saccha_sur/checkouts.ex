defmodule SacchaSur.Checkouts do
  alias SacchaSur.Checkout


  import Ecto.Query, warn: false
  alias SacchaSur.Repo


  alias SacchaSur.Checkout
  alias SacchaSur.Country
  alias SacchaSur.State
  alias SacchaSur.City



  def create_checkout(attrs \\ %{}) do
    %Checkout{}
    |> Checkout.changeset(attrs)
    |> Repo.insert()
  end

  def change_checkout(%Checkout{} = checkout, attrs \\ %{}) do
    Checkout.changeset(checkout, attrs)
  end

  def get_checkout_by_order_id(order_id) do
    Repo.get_by(Checkout, order_id: order_id)
  end

  def update_checkout(%Checkout{} = checkout, attrs) do
    checkout
    |> Checkout.changeset(attrs)
    |> Repo.update()
  end

  def list_countries do
    Enum.map(Repo.all(Country), fn country -> country.name end)
  end


  def list_states do
    Enum.map(Repo.all(State), fn state -> state.name end)
  end

  def specific_states(country) do
    country = Repo.get_by(Country, name: country)
    Enum.map(Repo.all(from s in State, where: s.country_id == ^country.country_id), fn state -> state.name end)
  end

  def specific_cities(state) do
    state = Repo.get_by(State, name: state)
    Enum.map(Repo.all(from c in City, where: c.state_id == ^state.state_id), fn city -> city.name end)
  end


end
