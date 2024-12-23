defmodule PINXS.Transfers.TransferTest do
  use ExUnit.Case, async: true

  alias PINXS.Transfers.Transfer
  alias PINXS.BankAccounts.BankAccount
  alias PINXS.Recipients.Recipient
  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

  setup do
    transfer = %Transfer{
      amount: 5000,
      description: "Earnings"
    }

    bank_account = %BankAccount{
      name: "Rubius Hagrid",
      bank_name: "Gringotts",
      bsb: "806015",
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
    with_proxy("transfers/create.fixture") do
      {:ok, created_recipient} = Recipient.create(recipient, client)

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          client
        )

      assert created_transfer.token != nil
    end
  end

  test "Create a transfer with missing currency", %{transfer: transfer, recipient: recipient} do
    with_proxy("transfers/create_with_missing_currency.fixture") do
      {:ok, created_recipient} = Recipient.create(recipient, client)

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | recipient: created_recipient.token},
          client
        )

      assert created_transfer.token != nil
    end
  end

  test "Get all transfers" do
    with_proxy("transfers/get_all.fixture") do
      {:ok, %{items: [transfer | _]}} = Transfer.get_all(client)

      assert transfer != nil
    end
  end

  test "Get specific page of transfers" do
    with_proxy("transfers/get_all_by_page.fixture") do
      {:ok, %{items: items}} = Transfer.get_all(2, client)

      assert items == []
    end
  end

  test "Get a transfer", %{transfer: transfer, recipient: recipient} do
    with_proxy("transfers/get_specific_transfer.fixture") do
      {:ok, created_recipient} = Recipient.create(recipient, client)

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          client
        )

      {:ok, retrieved_transfer} = Transfer.get(created_transfer.token, client)

      assert created_transfer == retrieved_transfer
    end
  end

  test "Search for a transfer" do
    with_proxy("transfers/search.fixture") do
      {:ok, retrieved_transfers} = Transfer.search(%{query: "hagrid@hogwarts.wiz"}, client)

      assert retrieved_transfers.count == 17
      assert retrieved_transfers.items != []
    end
  end

  test "Get line items", %{transfer: transfer, recipient: recipient} do
    with_proxy("transfers/get_line_items.fixture") do
      {:ok, created_recipient} = Recipient.create(recipient, client)

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          client
        )

      {:ok, %{items: items}} = Transfer.get_line_items(created_transfer.token, client)

      assert items != []
    end
  end

  test "Get line items with page", %{transfer: transfer, recipient: recipient} do
    with_proxy("transfers/get_line_items_per_page.fixture") do
      {:ok, created_recipient} = Recipient.create(recipient, client)

      {:ok, created_transfer} =
        Transfer.create(
          %{transfer | currency: "AUD", recipient: created_recipient.token},
          client
        )

      {:ok, %{items: items}} = Transfer.get_line_items(created_transfer.token, 2, client)

      assert items == []
    end
  end
end
