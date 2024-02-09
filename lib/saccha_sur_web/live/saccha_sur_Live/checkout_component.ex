defmodule SacchaSurWeb.SacchaSurLive.CheckoutComponent do
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
        <.input field={@form[:email]} type="text" label="Email" required/>
        <.input field={@form[:phone]} type="text" label="Phone Number" required/>
        <.input field={@form[:shipping_address]} type="text" label="Shipping Address" required/>
        <.input field={@form[:house_number]} type="text" label="House Number" required/>
        <.input field={@form[:state]} type="text" label="State" required/>
        <.input field={@form[:city]} type="text" label="City" required/>
        <.input field={@form[:country]} type="text" label="Country" required/>
        <.input field={@form[:postal_code]} type="text" label="Postal Code" required/>
        <.input field={@form[:book_count]} type="text" label="Book Count" required/>
        <.input field={@form[:shipping_charge]} type="text" label="Shipping Charge" required/>
        <%!-- <.input field={@form[:order_id]} type="hidden" label="Order Id" required/> --%>
        <.input field={@form[:total_amount]} type="number" label="Total Amount" value="600"/>



        <p>How does one find a guru? I could think
            of only one way to get a definitive answer
            to this question. I had to ask my friend, the
            wise old musician, Bhaskar!</p>

          <p>Bhaskar was more than twice my age
            at that time. Even then, we had an easy
            and friendly relationship. Most times I
            would not have hesitated to call him my
            best friend. We talked about anything
            and everything.</p>


           <p>A few days later I met Bhaskar and asked him
            my question, “How does one find a Guru?”
            He looked at me very intently for a long time
            and then said, “You cannot!” took one of his
            very long pauses and continued, “The Guru
            finds you!”</p>

          <p>This was not the answer I was expecting.
            “Surely there is something one can do to find
            a guru?” feeling a little uncomfortable at the
            one-sidedness of the above statement.</p>



          <p>It looked like Bhaskar had lost interest in
            the question but he was merely lost in his
            thoughts. He came back and responded,
            “No, not really. The Guru finds you.”</p>

           <p> “I cannot accept that”, I said forcefully,
            “I have always found my own teachers…” </p>

          <p>“AHA!” he said, “Teachers! Yes, you can find
            your own teachers but the guru has to find
            you. There is no other way.”</p>

         <p>Now I was confused.</p>

          <p>“What is the difference between a teacher
            and a guru?” I asked.</p>

          <p>(Story continues in the full book...)</p> <p>How does one find a guru? I could think
            of only one way to get a definitive answer
            to this question. I had to ask my friend, the
            wise old musician, Bhaskar!</p>

          <p>Bhaskar was more than twice my age
            at that time. Even then, we had an easy
            and friendly relationship. Most times I
            would not have hesitated to call him my
            best friend. We talked about anything
            and everything.</p>


           <p>A few days later I met Bhaskar and asked him
            my question, “How does one find a Guru?”
            He looked at me very intently for a long time
            and then said, “You cannot!” took one of his
            very long pauses and continued, “The Guru
            finds you!”</p>

          <p>This was not the answer I was expecting.
            “Surely there is something one can do to find
            a guru?” feeling a little uncomfortable at the
            one-sidedness of the above statement.</p>



          <p>It looked like Bhaskar had lost interest in
            the question but he was merely lost in his
            thoughts. He came back and responded,
            “No, not really. The Guru finds you.”</p>

           <p> “I cannot accept that”, I said forcefully,
            “I have always found my own teachers…” </p>

          <p>“AHA!” he said, “Teachers! Yes, you can find
            your own teachers but the guru has to find
            you. There is no other way.”</p>

         <p>Now I was confused.</p>

          <p>“What is the difference between a teacher
            and a guru?” I asked.</p>

          <p>(Story continues in the full book...)</p>


        <:actions>
          <.button  phx-disable-with="Saving...">pay</.button>
        </:actions>
      </.simple_form>

    </div>
    """
  end



  @impl true
   def update(%{checkout: checkout} = assigns, socket) do
    changeset = Checkouts.change_checkout(checkout)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end




  @impl true
  def handle_event("validate", %{"checkout" => checkout_params}, socket) do

    changeset =
      socket.assigns.checkout
      |> Checkouts.change_checkout(checkout_params)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign_form(changeset)}
  end

  def handle_event("save", %{"checkout" => checkout_params}, socket) do
    save_user(socket, socket.assigns.action, checkout_params)
  end

  defp save_user(socket, :checkout, checkout_params) do
    total_amount = Map.get(checkout_params, "total_amount") |> String.to_integer()
    order_id = Razorpay.call(total_amount)
    checkout_params = Map.put(checkout_params, "total_amount", total_amount)
    checkout_params = Map.put(checkout_params, "order_id", order_id)

    case Checkouts.create_checkout(checkout_params) do
      {:ok, checkout} ->

        # order_id = Map.get(checkout_params, "order_id")

        # notify_parent({:saved, user})

        {:noreply,
         socket
         |> redirect(to: ~p"/tellmeastory.guru?order=#{checkout.order_id}")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})


end
