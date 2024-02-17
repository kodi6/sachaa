defmodule SacchaSurWeb.SacchaSurLive.CheckoutComponent do
  use SacchaSurWeb, :live_component

  alias SacchaSur.Checkouts
  alias SacchaSur.Razorpay

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex items-center justify-center font-bold text-custom-orange text-2xl"><%= @title %></div>

    <.simple_form
      for={@form}
      id="pay-form"
      phx-target={@myself}
      phx-change="validate"
      phx-submit="save"
    >

      <div class="flex space-x-6 mb-20 justify-between">
        <div class="w-1/2 space-y-8">
            <%!-- <input type="text" name="Name" id="Name" class="block w-full h-[45px] rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-custom-orange sm:text-sm sm:leading-6" placeholder="you@example.com"> --%>
            <.check_input field={@form[:name]} type="text" label="Name" required/>
            <.check_input field={@form[:phone]} type="text" label="Phone" required/>
            <.check_input field={@form[:email]} type="text" label="Email" required/>
            <.check_input field={@form[:shipping_address]} type="textarea" label="Shipping Address" required/>
            <.check_input field={@form[:house_number]} type="text" label="House Number" required/>
        </div>

        <div class="w-1/2 space-y-8">
        <.check_input field={@form[:country]} type="select" label="Country"  prompt="Select Country" options={@conutries}  phx-change="country" value={@country} required/>
          <%= if @country != nil do %>
            <%= if @states != [] do %>
          <.check_input field={@form[:state]} type="select" label="State" prompt="Select State" options={states(@country)}  phx-change="state" value={@state} required/>
            <%= if @cities != [] do %>
          <.check_input field={@form[:city]} type="select" label="City" prompt="Select City" options={cities(@state)}  value={@city} phx-change="city" required/>
            <% end %>
          <% IO.inspect(@city, label: "city") %>
            <% end %>
          <% end %>
        <.check_input field={@form[:postal_code]} type="text" label="Postal Code" required/>
        <div class="flex items-center space-x-[73px]">
            <label for="Book Count" class="block text-base font-medium leading-6 text-gray-900 ">Quantity</label>
            <div class="flex items-center justify-between block w-[330px] h-[45px] rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-custom-orange sm:text-sm sm:leading-6">
              <div class="ml-3 flex items-center justify-center">
              <img class="w-4 h-4" src="/images/Rupee-Symbol-Black.svg" alt="logo">

              <div class="text-xl font-medium"><%= @book_price %></div>
              </div>
              <div class="w-[100px] h-[30px] flex mr-3">
                <button phx-click="decrease"  phx-value-count={@count} phx-target={@myself} class="rounded-md border-solid border-2 border-custom-orange w-1/3 h-[30px] flex items-center justify-center"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#FF6A00" class="w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" d="M5 12h14" /></svg></button>
                <div class="w-1/3  flex items-center justify-center"><%= @count %></div>
                <button  phx-click="increase" phx-value-count={@count} phx-target={@myself} class="rounded-md bg-custom-orange w-1/3  flex items-center justify-center"><svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="white" class="w-6 h-6"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" /></svg></button>
              </div>
            </div>
        </div>

        <.check_input field={@form[:shipping_charge]} type="text" label="Shipping Charge" required/>
        <.check_input field={@form[:book_count]} type="hidden"  value={@count} required/>
        </div>
      </div>
        <div class="w-full flex h-[70px] text-base font-medium">
          <div class=" w-3/4 flex flex-col justify-between h-full">
            <div class="border-dashed border-2 border-custom-orange ..."></div>
            <div class="">Total Amount</div>
            <div class="border-solid border-2 border-gray-300 "></div>
          </div>

          <div class="flex items-center justify-center bg-custom-orange text-white rounded-md w-1/4">
            <span class="text-xl mr-4">PAY</span>
            <img class="w-4 h-4" src="/images/Rupee-Symbol-White.svg" alt="logo">
            <div class="text-xl font-medium"> <%= @book_price %></div>
          </div>
        </div>
        <.check_input field={@form[:total_amount]} type="hidden"  value={@book_price} required/>

        <.button phx-disable-with="Saving...">Save User</.button>
    </.simple_form>

    </div>
    """
  end

  @impl true
   def update(%{checkout: checkout} = assigns, socket) do
    changeset = Checkouts.change_checkout(checkout)
    conutries = Checkouts.list_countries()
    states = Checkouts.list_states()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:country, nil)
     |> assign(:state, nil)
     |> assign(:city, nil)
     |> assign(:cities, nil)
     |> assign(:conutries, conutries)
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
  def handle_event("decrease", _event, socket) when socket.assigns.count > 1 do
    count = socket.assigns.count - 1
    book_price = count * 655
    {:noreply,
    socket
    |> assign(:count, count)
    |> assign(:book_price, book_price)
  }
  end

  def handle_event("decrease", _event, socket) do
    {:noreply,
    socket}
  end

  def handle_event("increase", _event, socket) do
    count = socket.assigns.count + 1
    book_price = count * 655
    {:noreply,
    socket
    |> assign(:count, count)
    |> assign(:book_price, book_price)}
  end

  def handle_event("country",  %{"checkout" => %{"country" => country}}, socket) do
    states = Checkouts.specific_states(country)
    states = case states do
      [] -> []
      _ -> Checkouts.specific_states(country)
    end
    {:noreply,
    socket
    |> assign(:states, states)
    |> assign(:country, country)
    |> assign(:city, nil)}
  end

  def handle_event("state",  %{"checkout" => %{"state" => state}}, socket) do
    cities = Checkouts.specific_cities(state)
      cities = case cities do
        [] -> []
        _ -> Checkouts.specific_cities(state)
      end
    {:noreply,
    socket
    |> assign(:cities, cities)
    |> assign(:state, state)
    }
  end


  def handle_event("city",  %{"checkout" => %{"city" => city}}, socket) do
    {:noreply,
    socket
    |> assign(:city, city)}
  end

  def states(country) do
    case country do
      nil -> []
      _ -> Checkouts.specific_states(country)
    end
  end

  def cities(state) do
    case state do
      nil -> []
      _ -> Checkouts.specific_cities(state)
    end
  end

end
