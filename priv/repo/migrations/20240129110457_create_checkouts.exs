defmodule SacchaSur.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :name, :string
      add :phone, :string
      add :email, :string
      add :shipping_address, :string
      add :house_number, :string
      add :state, :string
      add :city, :string
      add :country, :string
      add :postal_code, :string
      add :book_count, :string
      add :shipping_charge, :text
      add :total_amount, :decimal
      add :order_id, :string
      add :razorpay_payment_id, :string
      add :razorpay_signature, :string
      timestamps(type: :utc_datetime)
    end
  end
end
