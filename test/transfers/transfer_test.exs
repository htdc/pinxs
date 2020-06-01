defmodule PINXS.Transfers.TransferTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.Transfers.Transfer
  alias PINXS.BankAccounts.BankAccount
  alias PINXS.Recipients.Recipient

  setup do
    transfer = %Transfer{
      amount: 5000,
      description: "Earnings"
    }

    bank_account = %BankAccount{
      name: "Rubius Hagrid",
      bank_name: "Gringotts",
      bsb: "123456",
      number: "123456"
    }

    recipient = %Recipient{
      name: "Rubius Hagrid",
      email: "hagrid@hogwarts.wiz",
      bank_account: bank_account
    }

    {:ok, transfer: transfer, recipient: recipient}
  end

  test "Create a transfer", %{transfer: transfer, recipient: recipient} do
    use_cassette("transfers/create") do
      {:ok, created_recipient} = Recipient.create(recipient, PINXS.config("api_key", :test))

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          PINXS.config("api_key", :test)
        )

      assert created_transfer.token != nil
    end
  end

  test "Create a transfer with missing currency", %{transfer: transfer, recipient: recipient} do
    use_cassette("transfers/create_with_missing_currency") do
      {:ok, created_recipient} = Recipient.create(recipient, PINXS.config("api_key", :test))

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | recipient: created_recipient.token},
          PINXS.config("api_key", :test)
        )

      assert created_transfer.token != nil
    end
  end

  test "Get all transfers" do
    use_cassette("transfers/get_all") do
      {:ok, %{items: [transfer | _]}} = Transfer.get_all(PINXS.config("api_key", :test))

      assert transfer != nil
    end
  end

  test "Get specific page of transfers" do
    use_cassette("transfers/get_all_by_page") do
      {:ok, %{items: items}} = Transfer.get_all(2, PINXS.config("api_key", :test))

      assert items == []
    end
  end

  test "Get a transfer", %{transfer: transfer, recipient: recipient} do
    use_cassette("transfers/get_specific_transfer") do
      {:ok, created_recipient} = Recipient.create(recipient, PINXS.config("api_key", :test))

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          PINXS.config("api_key", :test)
        )

      {:ok, retrieved_transfer} =
        Transfer.get(created_transfer.token, PINXS.config("api_key", :test))

      assert created_transfer == retrieved_transfer
    end
  end

  test "Search for a transfer" do
    use_cassette("transfers/search") do
      {:ok, retrieved_transfers} =
        Transfer.search(%{query: "hagrid@hogwarts.wiz"}, PINXS.config("api_key", :test))

      assert retrieved_transfers.count == 5
      assert retrieved_transfers.items != []
    end
  end

  test "Get line items", %{transfer: transfer, recipient: recipient} do
    use_cassette("transfers/get_line_items") do
      {:ok, created_recipient} = Recipient.create(recipient, PINXS.config("api_key", :test))

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          PINXS.config("api_key", :test)
        )

      {:ok, %{items: items}} =
        Transfer.get_line_items(created_transfer.token, PINXS.config("api_key", :test))

      assert items != []
    end
  end
end
