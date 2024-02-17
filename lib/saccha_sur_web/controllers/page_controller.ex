defmodule SacchaSurWeb.PageController do
  use SacchaSurWeb, :controller

  alias SacchaSur.Checkouts
  alias SacchaSur.CustomerEmail
  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end


  def verify_payment(conn, params) do
    # Extract necessary data from params
    IO.inspect(params, label: "bb")
    order_id = params["order_id"]
    razorpay_payment_id = params["razorpay_payment_id"]
    razorpay_signature = params["razorpay_signature"]
    secret = "GdrW76lQF3AsdpvLicb26JTm"

    generated_signature = :crypto.mac(:hmac, :sha256, secret, "#{order_id}|#{razorpay_payment_id}") |> Base.encode16(case: :lower)

    record = Checkouts.get_checkout_by_order_id(order_id)

    if razorpay_signature == generated_signature do

      # name = record.name
      # email = record.email

      # CustomerEmail.successful_message(record)

      Checkouts.update_checkout(record, %{razorpay_payment_id: razorpay_payment_id, razorpay_signature: razorpay_signature})
      conn
      |> put_flash(:info, "Payment successful")
      |> redirect(to: "/tellmeastory.guru")
    else
      conn
      |> put_flash(:error, "Payment verification failed")
      |> redirect(to: "/tellmeastory.guru")
    end
  end




end
