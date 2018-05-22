defmodule PinPayments.Charges.ChargeTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PinPayments.Charges.Charge
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
    charge = %Charge{
      email: "hagrid@hogwarts.wiz",
      description: "Dragon eggs",
      ip_address: "127.0.0.1",
      amount: 50000,
    }
    card_token = "card_R6khtY81EZE5RiqkidVhgA"
    customer = %Customer{email: "hagrid@hogwarts.wiz", card: card}
    {:ok, card: card, charge: charge, card_token: card_token, customer: customer}
  end

  test "Create a charge with full card details", %{card: card, charge: charge} do
    use_cassette("charge_with_card") do
      charge = %{ charge | card: card }
      {:ok, charge} = Charge.create(charge)
      assert charge.amount == 50000
      assert charge.email == "hagrid@hogwarts.wiz"
      assert charge.card.token == "card_R6khtY81EZE5RiqkidVhgA"
      assert charge.captured == true
    end
  end

  test "Create an uncaptured charge", %{card: card, charge: charge} do
    use_cassette("charge_uncaptured") do
      charge = %{ charge | card: card, capture: false}
      {:ok, charge} = Charge.create(charge)

      assert charge.captured == false
    end
  end

  test "Create a charge with a used token", %{charge: charge, card_token: card_token} do
    use_cassette("charge_with_used_card_token") do
      charge_map = %{ charge | card_token: card_token}
      {:error, err} = Charge.create(charge_map)

      assert err.error_description == "Token already used. Card tokens can only be used once, to create a charge or assign a card to a customer"
    end
  end

  test "Create a charge with a card token", %{card: card_map, charge: charge} do
    use_cassette("charge_with_card_token") do
      {:ok, card} = Card.create(card_map)

      charge_map = %{ charge | card_token: card.token }

      {:ok, charge} = Charge.create(charge_map)


      assert charge.captured == true
      assert charge.amount == 50000
    end
  end


  test "Create a charge with a customer token", %{charge: charge, customer: customer} do
    use_cassette("charge_with_customer_token") do
      {:ok, customer} = Customer.create(customer)

      charge_map = %{ charge | customer_token: customer.token }

      {:ok, charge} = Charge.create(charge_map)


      assert charge.captured == true
      assert charge.amount == 50000
    end
  end

  test "Capture a charge", %{charge: charge, card: card} do
    use_cassette("capture_full_charge") do
      {:ok, uncaptured_charge} = Charge.create(%{ charge | capture: false, card: card})

      assert uncaptured_charge.captured == false

      {:ok, captured_charge} = Charge.capture(uncaptured_charge)

      assert captured_charge.captured == true
    end
  end

  test "Capture a partial charge", %{charge: charge, card: card} do
    use_cassette("capture_partial_charge") do
      {:ok, uncaptured_charge} = Charge.create(%{ charge | capture: false, card: card})

      assert uncaptured_charge.captured == false

      {:error, err} = Charge.capture(uncaptured_charge, %{amount: 200})

      assert err.error_description == "You must capture the full amount that was authorised"
    end
  end

  test "Get all charges" do
    use_cassette("get_all_charges") do
      {:ok, charges} = Charge.get_all()

      %{ items: [charge | _]} = charges

      assert charge.amount == 50000
      assert length(charges.items) == 25
    end
  end

  test "Get a specific charge", %{charge: charge, card: card} do
    {:ok, created_charge} = Charge.create(%{ charge | card: card})

    {:ok, retreived_charge} = Charge.get(created_charge.token)

    assert created_charge == retreived_charge
  end

end
