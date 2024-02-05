defmodule SacchaSurWeb.SacchaSurLive.PayComponent do
  use SacchaSurWeb, :live_component

  alias SacchaSur.Checkouts
  alias SacchaSur.Razorpay

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="pay-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" required/>
        <.input field={@form[:email]} type="text" label="email" required/>

        <.input field={@form[:amount]} type="number" label="Amount" value="600"/>

        <%= if is_nil(@checkout) do %>
          <.button phx-click={JS.dispatch("rzp", detail: %{})} phx-disable-with="Saving...">go to payment</.button>
        <% end %>

      </.simple_form>

      <.button         phx-target={@myself}
phx-click="click" phx-disable-with="Saving...">go to payment</.button>

    </div>
    """
  end



  @impl true
   def update(%{pay: pay} = assigns, socket) do
    changeset = Checkouts.change_checkout(pay)

    {:ok,
     socket
     |> assign(:checkout, nil)
     |> assign(assigns)
     |> assign_form(changeset)}
  end


  @impl true
  def handle_event("validate", %{"checkout" => pay_params}, socket) do

    changeset =
      socket.assigns.pay
      |> Checkouts.change_checkout(pay_params)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign_form(changeset)}
  end

  def handle_event("save", %{"checkout" => pay_params}, socket) do
    save_user(socket, socket.assigns.action, pay_params)
  end

  defp save_user(socket, :pay, pay_params) do
    amount = Map.get(pay_params, "amount") |> String.to_integer()
    order_id = Razorpay.call(amount)
    pay_params = Map.put(pay_params, "amount", amount)
    pay_params = Map.put(pay_params, "order_id", order_id)
    pay_params = Map.put(pay_params, "currency", "INR") ##look after


    case Checkouts.create_checkout(pay_params) do
      {:ok, checkout} ->

        IO.inspect(checkout, label: "checkout")
        send(self(), {:create_payment_intent, "hlloe"})

        # notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_navigate(to: ~p"/tellmeastory.guru?order=#{order_id}")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})



  def handle_event("click", _unsigned_params, socket) do
    send(self(), {:create_payment_intent, "hi"})

    {:noreply, socket}
  end



end
