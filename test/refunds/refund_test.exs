defmodule PINXS.Refunds.RefundTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.Cards.Card
  alias PINXS.Charges.Charge
  alias PINXS.Refunds.Refund
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
      {:ok, created_charge} =
        Charge.create(%{charge | card: card}, PINXS.config("api_key", :test))

      {:ok, refund} = Refund.create(created_charge, PINXS.config("api_key", :test))

      assert refund.amount == 50000
      assert refund.token != nil
    end
  end

  test "Get all refunds" do
    use_cassette("refunds/get_all") do
      {:ok, refunds} = Refund.get_all(PINXS.config("api_key", :test))

      assert length(refunds.items) == 10
    end
  end

  test "Get a refund", %{charge: charge, card: card} do
    use_cassette("refunds/get_one") do
      {:ok, created_charge} =
        Charge.create(%{charge | card: card}, PINXS.config("api_key", :test))

      {:ok, refund} = Refund.create(created_charge, PINXS.config("api_key", :test))

      {:ok, retrieved_refund} = Refund.get(refund, PINXS.config("api_key", :test))

      assert refund == retrieved_refund
    end
  end

  test "Get refunds for a charge", %{charge: charge, card: card} do
    use_cassette("refunds/get_refunds_for_charge") do
      {:ok, created_charge} =
        Charge.create(%{charge | card: card}, PINXS.config("api_key", :test))

      {:ok, refund} = Refund.create(created_charge, PINXS.config("api_key", :test))

      {:ok, retrieved_refunds} =
        Refund.get_all_for_charge(created_charge, PINXS.config("api_key", :test))

      assert [refund] == retrieved_refunds.items
    end
  end

  describe "new client" do
    test "Create a refund", %{charge: charge, card: card} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/refunds/create.fixture") do
        client = client(address)
        {:ok, created_charge} =
          Charge.create(%{charge | card: card}, client)

        {:ok, refund} = Refund.create(created_charge, client)

        assert refund.amount == 50000
        assert refund.token != nil
      end
    end

    test "Get all refunds" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/refunds/get_all.fixture") do
        {:ok, refunds} = Refund.get_all(client(address))

        assert length(refunds.items) == 25
      end
    end

    test "Get a refund", %{charge: charge, card: card} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/refunds/get_one.fixture") do
        client = client(address)
        {:ok, created_charge} =
          Charge.create(%{charge | card: card}, client)

        {:ok, refund} = Refund.create(created_charge, client)

        {:ok, retrieved_refund} = Refund.get(refund, client)

        assert refund == retrieved_refund
      end
    end

    test "Get refunds for a charge", %{charge: charge, card: card} do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/refunds/get_refunds_for_charge.fixture") do
        client = client(address)
        {:ok, created_charge} =
          Charge.create(%{charge | card: card}, client)

        {:ok, refund} = Refund.create(created_charge, client)

        {:ok, retrieved_refunds} =
          Refund.get_all_for_charge(created_charge, client)
        assert [refund] == retrieved_refunds.items
      end
    end
  end
end
