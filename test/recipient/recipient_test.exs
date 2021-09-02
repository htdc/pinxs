defmodule PINXS.Recipient.RecipientTest do
  use ExUnit.Case, async: true

  alias PINXS.Recipients.Recipient
  alias PINXS.BankAccounts.BankAccount

  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

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
    with_proxy("recipients/create.fixture") do
      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          client
        )

      assert created.token != nil
    end
  end

  test "Create recipient from bank account token", %{
    recipient: recipient,
    bank_account: bank_account
  } do
    with_proxy("recipients/create_from_token.fixture") do
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
    with_proxy("recipients/get.fixture") do
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
    with_proxy("recipients/get_all.fixture") do
      {:ok, %{items: [recipient | _]}} = Recipient.get_all(client)

      assert recipient.token =~ ~r/rp_.*/
    end
  end

  test "Update recipient with new bank account", %{
    recipient: recipient,
    bank_account: bank_account
  } do
    with_proxy("recipients/update.fixture") do
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
