defmodule PINXS.Customers.CustomerTest do
  use ExUnit.Case, async: true

  alias PINXS.Cards.Card
  alias PINXS.Customers.Customer
  alias PINXS.Charges.Charge

  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

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
    with_proxy("create_customer.fixture") do
      {:ok, customer} = Customer.create(customer, client)

      assert customer.token == "cus_--WoYjMhIsbglISJqdNHMA"
    end
  end

  test "Create customer with missing information", %{card: card} do
    with_proxy("create_customer_with_missing_fields.fixture") do
      {:error, err} = Customer.create(%Customer{card: card}, client)

      assert err.error_description == "One or more parameters were missing or invalid"
    end
  end

  test "Get all customers" do
    with_proxy("get_all_customers.fixture") do
      {:ok, customers} = Customer.get_all(client)

      assert length(customers.items) == 2
    end
  end

  test "Get paged customers" do
    with_proxy("get_paged_customers.fixture") do
      {:ok, customers} = Customer.get_all(2, client)

      assert customers.items == []
      assert customers.pagination.pages == 1
    end
  end

  test "Get single customer" do
    with_proxy("get_customer.fixture") do
      {:ok, customer} = Customer.get("cus_--WoYjMhIsbglISJqdNHMA", client)

      assert customer.email == "hagrid@hogwarts.wiz"
    end
  end

  test "Get a non existing customer" do
    with_proxy("get_non_existing_customer.fixture") do
      {:error, response} = Customer.get("whatevs", client)

      assert response.error == "not_found"
    end
  end

  test "Update a customer" do
    with_proxy("update_customer.fixture") do
      {:ok, customer} = Customer.get("cus_--WoYjMhIsbglISJqdNHMA", client)
      to_update = %{email: "hagrid@gmail.com"}
      {:ok, updated} = Customer.update(customer, to_update, client)

      assert updated.email == "hagrid@gmail.com"
    end
  end

  test "Delete a customer", %{customer: customer} do
    with_proxy("delete_customer.fixture") do
      {:ok, created_customer} = Customer.create(customer, client)

      {:ok, deleted} = Customer.delete(created_customer, client)

      assert deleted == true
    end
  end

  test "Get customer's charges", %{customer: customer} do
    with_proxy("get_customer_charges.fixture") do
      {:ok, created_customer} = Customer.create(customer, client)

      charge = %Charge{
        email: "hagrid@hogwarts.wiz",
        description: "Dragon eggs",
        ip_address: "127.0.0.1",
        amount: 50_000,
        customer_token: created_customer.token
      }

      {:ok, _} = Charge.create(charge, client)

      {:ok, %{items: [charge | _]}} = Customer.get_charges(created_customer, client)

      assert charge.description == "Dragon eggs"
    end
  end

  test "Get customer's cards", %{customer: customer} do
    with_proxy("get_customer_cards.fixture") do
      {:ok, created_customer} = Customer.create(customer, client)

      {:ok, %{items: [card | _]}} = Customer.get_cards(created_customer, client)

      assert card.expiry_year == 2020
    end
  end

  test "Add card to customer", %{customer: customer, card: card} do
    with_proxy("add_card_to_customer.fixture") do
      {:ok, created_customer} = Customer.create(customer, client)

      {:ok, created_card} =
        Customer.add_card(
          created_customer,
          %{card | expiry_year: 2020},
          client
        )

      assert created_card.expiry_year == 2020
    end
  end

  test "Add card to customer with token", %{customer: customer, card: card} do
    with_proxy("add_card_token_to_customer.fixture") do
      {:ok, created_customer} = Customer.create(customer, client)

      {:ok, created_card} = Card.create(%{card | expiry_year: 2021}, client)

      {:ok, added_card} = Customer.add_card(created_customer, created_card.token, client)

      assert added_card.expiry_year == 2021
    end
  end

  test "Delete customer card", %{customer: customer, card: card} do
    with_proxy("delete_customer_card.fixture") do
      {:ok, created_customer} = Customer.create(customer, client)

      {:ok, created_card} =
        Customer.add_card(
          created_customer,
          %{card | expiry_year: 2021},
          client
        )

      {:ok, delete_card} = Customer.delete_card(created_customer, created_card.token, client)

      assert delete_card == true
    end
  end
end
