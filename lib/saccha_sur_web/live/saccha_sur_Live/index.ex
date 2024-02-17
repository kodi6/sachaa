defmodule SacchaSurWeb.SacchaSurLive.Index do
  use SacchaSurWeb, :live_view

  alias SacchaSur.Checkout
  alias SacchaSur.Checkouts

  @impl true
  def mount(params, _session, socket) do

    [email, name] = if params == %{} do
      [nil, nil]
    else
    order_id = Map.get(params, "order")
    record = Checkouts.get_checkout_by_order_id(order_id)
    [record.email, record.name]
    end

    {:ok,
    socket
    |> assign(:name, name)
    |> assign(:email, email)


  }
  end



  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :checkout, params) do

    socket
    |> assign(:page_title, "checkout")
    |> assign(:checkout, %Checkout{})
    |> assign(:count, 1)
    |> assign(:book_price, 655)

  end

  defp apply_action(socket, :story, _params) do
    socket
  end

  defp apply_action(socket, :index, _params) do
    socket
  end





end
