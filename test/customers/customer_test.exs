defmodule PinPayments.Customers.CustomerTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PinPayments.Cards.Card
  alias PinPayments.Customers.Customer

  setup do
    card = %Card{
      number: "5520000000000000",
      expiry_month: "12",
      expiry_year: "20",
      name: "Rubius Hagrid",
      address_line1: "The Game Keepers Cottage",
      address_city: "Hogwarts",
      address_country: "England",
      cvc: "321"
    }
    customer = %Customer{email: "hagrid@hogwarts.wiz", card: card}

    {:ok, customer: customer, card: card}
  end

  test "Creating a customer", %{customer: customer} do
    use_cassette("create_customer") do
      {:ok, customer} = Customer.create(customer)

      assert customer.token == "cus_8xtSjuld0NFEzWnUOY0yeA"
    end
  end

  test "Create customer with missing information", %{card: card} do
    use_cassette("create_customer_with_missing_fields") do
      {:error, err} = Customer.create(%Customer{card: card})

      assert err.body.error_description == "One or more parameters were missing or invalid"
    end
  end
end
