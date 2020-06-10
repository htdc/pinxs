defmodule PINXS.BalanceTest do
  use ExUnit.Case, async: true
  alias PINXS.Balance
  use Nug
  import PINXS.TestHelpers

  test "Retrieve balance" do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/balance.fixture") do
      {:ok, balance} = Balance.get(client(address))
      assert balance.available == [%{amount: 50_000, currency: "AUD"}]
    end
  end
end
