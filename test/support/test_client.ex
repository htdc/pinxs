defmodule PINXS.TestClient do
  def setup(address) do
    Process.put(:client_url, address)

    test_key = PINXS.config(System.get_env("PIN_TEST_API_KEY"))

    PINXS.Client.new(test_key, address)
  end
end
