defmodule SacchaSur.Repo do
  use Ecto.Repo,
    otp_app: :saccha_sur,
    adapter: Ecto.Adapters.Postgres
end
