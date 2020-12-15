defmodule PINXS.Charges.ChargeTest do
  use ExUnit.Case, async: true

  alias PINXS.Charges.Charge
  alias PINXS.Cards.Card
  alias PINXS.Customers.Customer
  import PINXS.TestHelpers
  use Nug

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

    charge = %Charge{
      email: "hagrid@hogwarts.wiz",
      description: "Dragon eggs",
      ip_address: "127.0.0.1",
      amount: 50_000
    }

    card_token = "card_R6khtY81EZE5RiqkidVhgA"
    customer = %Customer{email: "hagrid@hogwarts.wiz", card: card}
    {:ok, card: card, charge: charge, card_token: card_token, customer: customer}
  end

  test "Create a charge with full card details", %{card: card, charge: charge} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/create_charge.fixture") do
      client = client(address)
      charge = %{charge | card: card}
      {:ok, charge} = Charge.create(charge, client)
      assert charge.amount == 50_000
      assert charge.email == "hagrid@hogwarts.wiz"
      assert charge.card.token == "card_u2vD9fa5icjORwtWm8t6dw"
      assert charge.captured == true
    end
  end

  test "Create a charge with a card token", %{card: card_map, charge: charge} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/charge_with_card_token.fixture") do
      {:ok, card} = Card.create(card_map, client(address))

      charge_map = %{charge | card_token: card.token}

      {:ok, charge} = Charge.create(charge_map, client(address))

      assert charge.captured == true
      assert charge.amount == 50_000
    end
  end

  test "Create a charge with a customer token", %{charge: charge, customer: customer} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/charge_with_customer_token.fixture") do
      {:ok, customer} = Customer.create(customer, client(address))

      charge_map = %{charge | customer_token: customer.token}

      {:ok, charge} = Charge.create(charge_map, client(address))

      assert charge.captured == true
      assert charge.amount == 50_000
    end
  end

  test "Capture a charge", %{charge: charge, card: card} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/capture_full_charge.fixture") do
      {:ok, uncaptured_charge} =
        Charge.create(%{charge | capture: false, card: card}, client(address))

      assert uncaptured_charge.captured == false

      {:ok, captured_charge} = Charge.capture(uncaptured_charge, client(address))

      assert captured_charge.captured == true
    end
  end

  test "Capture a partial charge", %{charge: charge, card: card} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/capture_partial_charge.fixture") do
      {:ok, uncaptured_charge} =
        Charge.create(%{charge | capture: false, card: card}, client(address))

      assert uncaptured_charge.captured == false

      {:error, err} = Charge.capture(uncaptured_charge, %{amount: 200}, client(address))

      assert err.error_description == "You must capture the full amount that was authorised"
    end
  end

  test "Get all charges" do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/get_all_charges.fixture") do
      {:ok, charges} = Charge.get_all(client(address))

      %{items: [charge | _]} = charges

      assert charge.amount == 50_000
      assert length(charges.items) == 25
    end
  end

  test "Get a specific charge", %{charge: charge, card: card} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/get_charge.fixture") do
      {:ok, created_charge} = Charge.create(%{charge | card: card}, client(address))

      {:ok, retreived_charge} = Charge.get(created_charge.token, client(address))

      assert created_charge == retreived_charge
    end
  end

  test "Search for a charge" do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/search_charges.fixture") do
      {:ok, retreived_charges} = Charge.search([query: "hagrid@hogwarts.wiz"], client(address))

      assert retreived_charges.count == 25
      assert retreived_charges.items != []
    end
  end

  test "Void an authed charge", %{charge: charge, card: card} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/void-auth.fixture") do
      {:ok, uncaptured_charge} =
        Charge.create(%{charge | capture: false, card: card}, client(address))

      assert uncaptured_charge.authorisation_voided == false

      {:ok, voided_charge} = Charge.void(uncaptured_charge.token, client(address))

      assert voided_charge.authorisation_voided == true
    end
  end

end
