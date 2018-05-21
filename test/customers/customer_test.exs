defmodule PinPayments.Customers.CustomerTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PinPayments.Cards.Card
  alias PinPayments.Customers.Customer
  alias PinPayments.Charges.Charge

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

      assert err.error_description == "One or more parameters were missing or invalid"
    end
  end

  test "Get all customers" do
    use_cassette("get_all_customers") do
      {:ok, customers} = Customer.get_all()

      assert length(customers.items) == 10
    end
  end

  test "Get paged customers" do
    use_cassette("get_paged_customers") do
      {:ok, customers} = Customer.get_all(2)

      assert customers.items == []
      assert customers.pagination.pages == 1
    end
  end

  test "Get single customer" do
    use_cassette("get_customer") do
      {:ok, customer} = Customer.get("cus_8xtSjuld0NFEzWnUOY0yeA")

      assert customer.email == "hagrid@hogwarts.wiz"
    end
  end

  test "Get a non existing customer" do
    use_cassette("get_non_existing_customer") do
      {:error, response} = Customer.get("whatevs")

      assert response.error == "not_found"
    end
  end

  test "Update a customer" do
    use_cassette("update_customer") do
      {:ok, customer} = Customer.get("cus_8xtSjuld0NFEzWnUOY0yeA")
      to_update = %{email: "hagrid@gmail.com"}
      {:ok, updated} = Customer.update(customer, to_update)

      assert updated.email == "hagrid@gmail.com"
    end
  end

  test "Delete a customer", %{customer: customer} do
    use_cassette("delete_customer") do
      {:ok, created_customer} = Customer.create(customer)


      {:ok, deleted} = Customer.delete(created_customer)

      assert deleted == true
    end
  end

  test "Get customer's charges", %{customer: customer} do
    use_cassette("get_customer_charges") do
      {:ok, created_customer} = Customer.create(customer)

      charge = %Charge{
        email: "hagrid@hogwarts.wiz",
        description: "Dragon eggs",
        ip_address: "127.0.0.1",
        amount: 50000,
        customer_token: created_customer.token
      }
      {:ok, _} = Charge.create(charge)

      {:ok, %{items: [ charge | _ ]}} = Customer.get_charges(created_customer)

      assert charge.description == "Dragon eggs"
    end
  end

  test "Get customer's cards", %{customer: customer} do
    {:ok, created_customer} = Customer.create(customer)
    {:ok, %{items: [ card | _ ]}} = Customer.get_cards(created_customer)

    assert card.expiry_year == 2020
  end


end
