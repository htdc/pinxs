defmodule PINXS do
  @moduledoc """
  Convenience functions for building config structs
  """
  @enforce_keys [:api_key]
  defstruct [:api_key, :url]

  @type t :: %__MODULE__{
          api_key: String.t(),
          url: String.t()
        }

  @doc """
  Default usage is to just provide the api key

      iex> PINXS.config("ABC123")
      %PINXS{api_key: "ABC123", url: "https://api.pinpayments.com/1"}
  """

  def config(api_key) do
    %PINXS{api_key: api_key, url: "https://api.pinpayments.com/1"}
  end

  @doc """
  If you want to use test mode

      iex> PINXS.config("ABC123", :test)
      %PINXS{api_key: "ABC123", url: "https://test-api.pinpayments.com/1"}

  Or you can have an arbitrary URL

      iex> PINXS.config("ABC123", "https://my-fake-pin")
      %PINXS{api_key: "ABC123", url: "https://my-fake-pin"}
  """
  def config(api_key, :test) do
    %PINXS{api_key: api_key, url: "https://test-api.pinpayments.com/1"}
  end

  def config(api_key, url) do
    %PINXS{api_key: api_key, url: url}
  end
end
