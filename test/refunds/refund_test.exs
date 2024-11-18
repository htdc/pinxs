defmodule PINXS.Refunds.RefundTest do
  use ExUnit.Case, async: true

  alias PINXS.Cards.Card
  alias PINXS.Charges.Charge
  alias PINXS.Refunds.Refund

  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

  setup do
    card = %Card{
      number: "5520000000000000",
      expiry_month: "12",
      expiry_year: "30",
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

    {:ok, charge: charge, card: card}
  end

  test "Create a refund", %{charge: charge, card: card} do
    with_proxy("refunds/create.fixture") do
      {:ok, created_charge} = Charge.create(%{charge | card: card}, client)

      {:ok, refund} = Refund.create(created_charge, client)

      assert refund.amount == 50_000
      assert refund.token != nil
    end
  end

  test "Get all refunds" do
    with_proxy("refunds/get_all.fixture") do
      {:ok, refunds} = Refund.get_all(client)

      assert length(refunds.items) == 20
    end
  end

  test "Get a refund", %{charge: charge, card: card} do
    with_proxy("refunds/get_one.fixture") do
      {:ok, created_charge} = Charge.create(%{charge | card: card}, client)

      {:ok, refund} = Refund.create(created_charge, client)

      {:ok, retrieved_refund} = Refund.get(refund, client)

      assert refund == retrieved_refund
    end
  end

  test "Get refunds for a charge", %{charge: charge, card: card} do
    with_proxy("refunds/get_refunds_for_charge.fixture") do
      {:ok, created_charge} = Charge.create(%{charge | card: card}, client)

      {:ok, refund} = Refund.create(created_charge, client)

      {:ok, retrieved_refunds} = Refund.get_all_for_charge(created_charge, client)
      assert [refund] == retrieved_refunds.items
    end
  end
end
