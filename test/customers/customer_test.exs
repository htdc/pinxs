defmodule PINXS.Customers.CustomerTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.Cards.Card
  alias PINXS.Customers.Customer
  alias PINXS.Charges.Charge
  use Nug
  import PINXS.TestHelpers

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
      {:ok, customer} = Customer.create(customer, PINXS.config("api_key", :test))

      assert customer.token == "cus_8xtSjuld0NFEzWnUOY0yeA"
    end
  end

  test "Create customer with missing information", %{card: card} do
    use_cassette("create_customer_with_missing_fields") do
      {:error, err} = Customer.create(%Customer{card: card}, PINXS.config("api_key", :test))

      assert err.error_description == "One or more parameters were missing or invalid"
    end
  end

  test "Get all customers" do
    use_cassette("get_all_customers") do
      {:ok, customers} = Customer.get_all(PINXS.config("api_key", :test))

      assert length(customers.items) == 10
    end
  end

  test "Get paged customers" do
    use_cassette("get_paged_customers") do
      {:ok, customers} = Customer.get_all(2, PINXS.config("api_key", :test))

      assert customers.items == []
      assert customers.pagination.pages == 1
    end
  end

  test "Get single customer" do
    use_cassette("get_customer") do
      {:ok, customer} = Customer.get("cus_8xtSjuld0NFEzWnUOY0yeA", PINXS.config("api_key", :test))

      assert customer.email == "hagrid@hogwarts.wiz"
    end
  end

  test "Get a non existing customer" do
    use_cassette("get_non_existing_customer") do
      {:error, response} = Customer.get("whatevs", PINXS.config("api_key", :test))

      assert response.error == "not_found"
    end
  end

  test "Update a customer" do
    use_cassette("update_customer") do
      {:ok, customer} = Customer.get("cus_8xtSjuld0NFEzWnUOY0yeA", PINXS.config("api_key", :test))
      to_update = %{email: "hagrid@gmail.com"}
      {:ok, updated} = Customer.update(customer, to_update, PINXS.config("api_key", :test))

      assert updated.email == "hagrid@gmail.com"
    end
  end

  test "Delete a customer", %{customer: customer} do
    use_cassette("delete_customer") do
      {:ok, created_customer} = Customer.create(customer, PINXS.config("api_key", :test))

      {:ok, deleted} = Customer.delete(created_customer, PINXS.config("api_key", :test))

      assert deleted == true
    end
  end

  test "Get customer's charges", %{customer: customer} do
    use_cassette("get_customer_charges") do
      {:ok, created_customer} = Customer.create(customer, PINXS.config("api_key", :test))

      charge = %Charge{
        email: "hagrid@hogwarts.wiz",
        description: "Dragon eggs",
        ip_address: "127.0.0.1",
        amount: 50000,
        customer_token: created_customer.token
      }

      {:ok, _} = Charge.create(charge, PINXS.config("api_key", :test))

      {:ok, %{items: [charge | _]}} =
        Customer.get_charges(created_customer, PINXS.config("api_key", :test))

      assert charge.description == "Dragon eggs"
    end
  end

  test "Get customer's cards", %{customer: customer} do
    use_cassette("get_customer_cards") do
      {:ok, created_customer} = Customer.create(customer, PINXS.config("api_key", :test))

      {:ok, %{items: [card | _]}} =
        Customer.get_cards(created_customer, PINXS.config("api_key", :test))

      assert card.expiry_year == 2020
    end
  end

  test "Add card to customer", %{customer: customer, card: card} do
    use_cassette("add_card_to_customer") do
      {:ok, created_customer} = Customer.create(customer, PINXS.config("api_key", :test))

      {:ok, created_card} =
        Customer.add_card(
          created_customer,
          %{card | expiry_year: 2019},
          PINXS.config("api_key", :test)
        )

      assert created_card.expiry_year == 2019
    end
  end

  test "Add card to customer with token", %{customer: customer, card: card} do
    use_cassette("add_card_token_to_customer") do
      {:ok, created_customer} = Customer.create(customer, PINXS.config("api_key", :test))

      {:ok, created_card} =
        Card.create(%{card | expiry_year: 2018}, PINXS.config("api_key", :test))

      {:ok, added_card} =
        Customer.add_card(created_customer, created_card.token, PINXS.config("api_key", :test))

      assert added_card.expiry_year == 2018
    end
  end

  test "Delete customer card", %{customer: customer, card: card} do
    use_cassette("delete_customer_card") do
      {:ok, created_customer} = Customer.create(customer, PINXS.config("api_key", :test))

      {:ok, created_card} =
        Customer.add_card(
          created_customer,
          %{card | expiry_year: 2019},
          PINXS.config("api_key", :test)
        )

      {:ok, delete_card} =
        Customer.delete_card(created_customer, created_card.token, PINXS.config("api_key", :test))

      assert delete_card == true
    end
  end

  describe "new client" do
    test "Creating a customer", %{customer: customer} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/create_customer.fixture") do
        {:ok, customer} = Customer.create(customer, client(address))

        assert customer.token == "cus_--WoYjMhIsbglISJqdNHMA"
      end
    end

    test "Create customer with missing information", %{card: card} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/create_customer_with_missing_fields.fixture") do
        {:error, err} = Customer.create(%Customer{card: card}, client(address))

        assert err.error_description == "One or more parameters were missing or invalid"
      end
    end

    test "Get all customers" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/get_all_customers.fixture") do
        {:ok, customers} = Customer.get_all(client(address))

        assert length(customers.items) == 2
      end
    end

    test "Get paged customers" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/get_paged_customers.fixture") do
        {:ok, customers} = Customer.get_all(2, client(address))

        assert customers.items == []
        assert customers.pagination.pages == 1
      end
    end

    test "Get single customer" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/get_customer.fixture") do
        {:ok, customer} = Customer.get("cus_--WoYjMhIsbglISJqdNHMA", client(address))

        assert customer.email == "hagrid@hogwarts.wiz"
      end
    end

    test "Get a non existing customer" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/get_non_existing_customer.fixture") do
        {:error, response} = Customer.get("whatevs", client(address))

        assert response.error == "not_found"
      end
    end

    test "Update a customer" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/update_customer.fixture") do
        {:ok, customer} = Customer.get("cus_--WoYjMhIsbglISJqdNHMA", client(address))
        to_update = %{email: "hagrid@gmail.com"}
        {:ok, updated} = Customer.update(customer, to_update, client(address))

        assert updated.email == "hagrid@gmail.com"
      end
    end

    test "Delete a customer", %{customer: customer} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/delete_customer.fixture") do
        {:ok, created_customer} = Customer.create(customer, client(address))

        {:ok, deleted} = Customer.delete(created_customer, client(address))

        assert deleted == true
      end
    end

    test "Get customer's charges", %{customer: customer} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/get_customer_charges.fixture") do
        client = client(address)
        {:ok, created_customer} = Customer.create(customer, client)

        charge = %Charge{
          email: "hagrid@hogwarts.wiz",
          description: "Dragon eggs",
          ip_address: "127.0.0.1",
          amount: 50000,
          customer_token: created_customer.token
        }

        {:ok, _} = Charge.create(charge, client)

        {:ok, %{items: [charge | _]}} =
          Customer.get_charges(created_customer, client)

        assert charge.description == "Dragon eggs"
      end
    end

    test "Get customer's cards", %{customer: customer} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/get_customer_cards.fixture") do
        client = client(address)
        {:ok, created_customer} = Customer.create(customer, client)

        {:ok, %{items: [card | _]}} =
          Customer.get_cards(created_customer, client)

        assert card.expiry_year == 2020
      end
    end

    test "Add card to customer", %{customer: customer, card: card} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/add_card_to_customer.fixture") do
        client = client(address)
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
      with_proxy(PINXS.Client.test_url(), "test/fixtures/add_card_token_to_customer.fixture") do
        client = client(address)
        {:ok, created_customer} = Customer.create(customer, client)

        {:ok, created_card} =
          Card.create(%{card | expiry_year: 2021}, client)

        {:ok, added_card} =
          Customer.add_card(created_customer, created_card.token, client)

        assert added_card.expiry_year == 2021
      end
    end

    test "Delete customer card", %{customer: customer, card: card} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/delete_customer_card.fixture") do
        client = client(address)
        {:ok, created_customer} = Customer.create(customer, client)

        {:ok, created_card} =
          Customer.add_card(
            created_customer,
            %{card | expiry_year: 2021},
            client
          )

        {:ok, delete_card} =
          Customer.delete_card(created_customer, created_card.token, client)

        assert delete_card == true
      end
    end
  end
end
