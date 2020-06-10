defmodule PINXS.BankAccounts.BankAccountTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.BankAccounts.BankAccount
  use Nug
  import PINXS.TestHelpers

  test "Create a bank account" do
    bank_account = %BankAccount{
      bank_name: "Gringotts",
      name: "Harry Potter",
      bsb: "123456",
      number: "123456",
      branch: "Diagon Alley"
    }

    use_cassette("bank_accounts/create") do
      {:ok, created_account} = BankAccount.create(bank_account, PINXS.config("api_key", :test))

      assert created_account.number == "XXX456"
      assert created_account.token == "ba_PRNU-gZfs7TAFYQN4fRT9g"
    end
  end

  describe "new client" do
    test "Create a charge with full card details" do
      bank_account = %BankAccount{
        bank_name: "Gringotts",
        name: "Harry Potter",
        bsb: "806015",
        number: "123456",
        branch: "Diagon Alley"
      }

      with_proxy(PINXS.Client.test_url(), "test/fixtures/bank_accounts_create.fixture") do

        {:ok, created_account} = BankAccount.create(bank_account, client(address))

        assert created_account.number == "XXX456"
        assert created_account.token == "ba_sik8FwkHtPMi7rjtSY0ibg"
      end
    end
  end
end
