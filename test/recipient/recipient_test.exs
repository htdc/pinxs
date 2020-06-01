defmodule PINXS.Recipient.RecipientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.Recipients.Recipient
  alias PINXS.BankAccounts.BankAccount

  setup do
    recipient = %Recipient{
      name: "Rubius Hagrid",
      email: "hagrid@hogwarts.wiz"
    }

    bank_account = %BankAccount{
      name: "Rubius Hagrid",
      bank_name: "Gringotts",
      bsb: "123456",
      number: "123456"
    }

    {:ok, recipient: recipient, bank_account: bank_account}
  end

  test "Create a recipient", %{recipient: recipient, bank_account: bank_account} do
    use_cassette("recipients/create") do
      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          PINXS.config("api_key", :test)
        )

      assert created.token != nil
    end
  end

  test "Create recipient from bank account token", %{
    recipient: recipient,
    bank_account: bank_account
  } do
    use_cassette("recipients/create_from_token") do
      {:ok, created_account} = BankAccount.create(bank_account, PINXS.config("api_key", :test))

      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account_token: created_account.token},
          PINXS.config("api_key", :test)
        )

      assert created.token != nil
    end
  end

  test "Get a recipient", %{recipient: recipient, bank_account: bank_account} do
    use_cassette("recipients/get") do
      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          PINXS.config("api_key", :test)
        )

      {:ok, retrieved} = Recipient.get(created.token, PINXS.config("api_key", :test))

      assert created == retrieved
    end
  end

  test "Get all" do
    use_cassette("recipients/get_all") do
      {:ok, %{items: [recipient | _]}} = Recipient.get_all(PINXS.config("api_key", :test))

      assert recipient.token =~ ~r/rp_.*/
    end
  end

  test "Update recipient with new bank account", %{
    recipient: recipient,
    bank_account: bank_account
  } do
    use_cassette("recipients/update") do
      {:ok, created} =
        Recipient.create(
          %{recipient | bank_account: bank_account},
          PINXS.config("api_key", :test)
        )

      {:ok, created_account} = BankAccount.create(bank_account, PINXS.config("api_key", :test))

      {:ok, updated_recipient} =
        Recipient.update_recipient(
          created,
          %{bank_account_token: created_account.token},
          PINXS.config("api_key", :test)
        )

      assert created.bank_account != updated_recipient.bank_account
    end
  end
end
