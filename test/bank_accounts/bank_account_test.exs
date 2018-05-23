defmodule PINXS.BankAccounts.BankAccountTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.BankAccounts.BankAccount

  test "Create a bank account" do
    bank_account = %BankAccount{
      bank_name: "Gringotts",
      name: "Harry Potter",
      bsb: "123456",
      number: "123456",
      branch: "Diagon Alley"
    }

    use_cassette("bank_accounts/create") do
      {:ok, created_account} = BankAccount.create(bank_account)

      assert created_account.number == "XXX456"
      assert created_account.token == "ba_PRNU-gZfs7TAFYQN4fRT9g"
    end
  end
end
