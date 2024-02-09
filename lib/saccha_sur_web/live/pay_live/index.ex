defmodule SacchaSurWeb.PayLive.Index do
  use SacchaSurWeb, :live_view


  def mount(params, _session, socket) do
IO.inspect(params, label: "params")
    {:ok, socket
    |> assign(:name, "hi")
  }
  end
end
