defmodule PINXS.Recipient.RecipientTest do
  use ExUnit.Case, async: true

  alias PINXS.Recipients.Recipient
  alias PINXS.BankAccounts.BankAccount
  use Nug
  import PINXS.TestHelpers

  setup do
    recipient = %Recipient{
      name: "Rubius Hagrid",
      email: "hagrid@hogwarts.wiz"
    }

    bank_account = %BankAccount{
      name: "Rubius Hagrid",
      bank_name: "Gringotts",
      bsb: "806015",
      number: "123456"
    }

    {:ok, recipient: recipient, bank_account: bank_account}
  end

  test "Create a recipient", %{recipient: recipient, bank_account: bank_account} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/recipients/create.fixture") do
      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          client(address)
        )

      assert created.token != nil
    end
  end

  test "Create recipient from bank account token", %{
    recipient: recipient,
    bank_account: bank_account
  } do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/recipients/create_from_token.fixture") do
      client = client(address)
      {:ok, created_account} = BankAccount.create(bank_account, client)

      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account_token: created_account.token},
          client
        )

      assert created.token != nil
    end
  end

  test "Get a recipient", %{recipient: recipient, bank_account: bank_account} do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/recipients/get.fixture") do
      client = client(address)

      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          client
        )

      {:ok, retrieved} = Recipient.get(created.token, client)

      assert created == retrieved
    end
  end

  test "Get all" do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/recipients/get_all.fixture") do
      {:ok, %{items: [recipient | _]}} = Recipient.get_all(client(address))

      assert recipient.token =~ ~r/rp_.*/
    end
  end

  test "Update recipient with new bank account", %{
    recipient: recipient,
    bank_account: bank_account
  } do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/recipients/update.fixture") do
      client = client(address)

      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          client
        )

      {:ok, created_account} = BankAccount.create(bank_account, client)

      {:ok, updated_recipient} =
        Recipient.update_recipient(
          created,
          %{bank_account_token: created_account.token},
          client
        )

      assert created.bank_account != updated_recipient.bank_account
    end
  end
end
