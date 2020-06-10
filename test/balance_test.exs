defmodule PINXS.BalanceTest do
  use ExUnit.Case, async: true
  alias PINXS.Balance
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Nug
  import PINXS.TestHelpers

  test "Retrieve balance" do
    use_cassette("balance") do
      {:ok, balance} = Balance.get(PINXS.config("api key", :test))
      assert balance.available == [%{amount: 50000, currency: "AUD"}]
    end
  end

  describe "new client" do
    test "Retrieve balance" do
      with_proxy(PINXS.Client.test_url(), "test/fixtures/balance.fixture") do
        {:ok, balance} = Balance.get(client(address))
        assert balance.available == [%{amount: 50000, currency: "AUD"}]
      end
    end
  end
end
