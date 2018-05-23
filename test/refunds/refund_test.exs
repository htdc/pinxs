defmodule PinPayments.Refunds.RefundTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PinPayments.Cards.Card
  alias PinPayments.Charges.Charge
  alias PinPayments.Refunds.Refund

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
      amount: 50000
    }
    {:ok, charge: charge, card: card}
  end

  test "Create a refund", %{charge: charge, card: card} do
    use_cassette("refunds/create") do
      {:ok, created_charge} = Charge.create(%{charge | card: card})

      {:ok, refund} = Refund.create(created_charge)

      assert refund.amount == 50000
      assert refund.token != nil
    end
  end

  test "Get all refunds" do
    use_cassette("refunds/get_all") do
      {:ok, refunds} = Refund.get_all()

      assert length(refunds.items) == 10
    end
  end

  test "Get a refund", %{charge: charge, card: card} do
    use_cassette("refunds/get_one") do
      {:ok, created_charge} = Charge.create(%{charge | card: card})

      {:ok, refund} = Refund.create(created_charge)

      {:ok, retrieved_refund} = Refund.get(refund)

      assert refund == retrieved_refund
    end
  end

  test "Get refunds for a charge", %{charge: charge, card: card} do
    use_cassette("refunds/get_refunds_for_charge") do
      {:ok, created_charge} = Charge.create(%{charge | card: card})

      {:ok, refund} = Refund.create(created_charge)

      {:ok, retrieved_refunds} = Refund.get_all_for_charge(created_charge)

      assert [refund] == retrieved_refunds.items
    end
  end

end
