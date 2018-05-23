defmodule PINXS.BalanceTest do
  use ExUnit.Case, async: true
  alias PINXS.Balance
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "Retrieve balance" do
    use_cassette("balance") do
      {:ok, balance} = Balance.get()
      assert balance.available == [%{amount: 50000, currency: "AUD"}]
    end
  end
end
