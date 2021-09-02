defmodule PINXS.BalanceTest do
  use ExUnit.Case, async: true
  alias PINXS.Balance

  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

  test "Retrieve balance" do
    with_proxy("balance.fixture") do
      {:ok, balance} = Balance.get(client)
      assert balance.available == [%{amount: 50_000, currency: "AUD"}]
    end
  end
end
