defmodule SacchaSurWeb.SacchaSurLive.Index do
  use SacchaSurWeb, :live_view

  alias SacchaSur.Checkout
  alias SacchaSur.Checkouts

  @impl true
  def mount(_params, _session, socket) do
    # IO.inspect(params, label: "params")

    # [email, order_id, name] = if params == %{} do
    #   [nil, nil, nil]
    # else

    # order_id = Map.get(params, "order")
    # record = Checkouts.get_checkout_by_order(order_id)
    # [record.email, record.order_id, record.name]
    # end



    {:ok,
    socket
    # |> assign(:email, email)
    # |> assign(:order_id, order_id)
    # |> assign(:name, name)

  }
  end

  def handle_info({:create_payment_intent, checkout}, socket) do
    IO.inspect(checkout, label: "checkoutsocket")

    # with {:ok, stripe_customer} <- Stripe.Customer.create(%{email: email, name: name}),
    #      {:ok, payment_intent} <- Stripe.PaymentIntent.create(%{customer: stripe_customer.id, amount: amount, currency: currency}) do

    #   # Update the checkout
    #   # Checkouts.update_checkout(checkout, %{payment_intent_id: payment_intent.id})

    #   {:noreply, socket}
    # else
    #   _ ->
    #     {:noreply, socket}
    # end
      {:noreply, socket}

  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end


  defp apply_action(socket, :pay, params) do

    socket
    |> assign(:page_title, "checkout")
    |> assign(:pay, %Checkout{})

  end

  defp apply_action(socket, :story, _params) do
    socket
  end

  defp apply_action(socket, :index, _params) do
    socket
  end




end
