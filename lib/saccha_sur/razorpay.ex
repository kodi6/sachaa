defmodule SacchaSur.Razorpay do
  def call(amount) do
    body = %{"currency" => "INR"}
    body = Map.put(body, "amount", amount)
    body
    |> Jason.encode!()
    |> request()
    |> response()
  end



  defp response({:ok, %Finch.Response{body: body}}) do
    params = Jason.decode!(body)
    id = Map.get(params, "id")
  end

  defp request(body) do
    headers = headers() # Retrieve headers
    Finch.build(:post, "https://api.razorpay.com/v1/orders", headers, body)
    |> Finch.request(SacchaSur.Finch)
  end

  defp headers do
    key_id = "rzp_test_270oaMCzf0ozoH"
    key_secret = "GdrW76lQF3AsdpvLicb26JTm"
    auth_header = "Basic #{Base.encode64("#{key_id}:#{key_secret}")}"

    [
      {"content-type", "application/json"},
      {"Authorization", auth_header}
    ]
  end
end
