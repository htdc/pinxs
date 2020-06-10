defmodule PINXS.TestHelpers do
  @moduledoc false
  def client(address) do
    test_keys = PINXS.config(System.get_env("PIN_TEST_API_KEY"))
    PINXS.Client.new(test_keys, "http://#{address}")
  end
end
