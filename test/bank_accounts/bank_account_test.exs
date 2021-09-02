defmodule PINXS.BankAccounts.BankAccountTest do
  use ExUnit.Case, async: true

  alias PINXS.BankAccounts.BankAccount

  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

  test "Create a charge with full card details" do
    bank_account = %BankAccount{
      bank_name: "Gringotts",
      name: "Harry Potter",
      bsb: "806015",
      number: "123456",
      branch: "Diagon Alley"
    }

    with_proxy("bank_accounts_create.fixture") do
      {:ok, created_account} = BankAccount.create(bank_account, client)

      assert created_account.number == "XXX456"
      assert created_account.token == "ba_sik8FwkHtPMi7rjtSY0ibg"
    end
  end
end
