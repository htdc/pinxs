defmodule PINXS.Charges.Charge do
  alias PINXS.HTTP.API
  alias __MODULE__

  @moduledoc """
  The Charge module provides functions for working wtih charges.

  ## Required Fields

  When creating a charge, the following fields are required.

  - email
  - description
  - amount
  - ip_address

  and one of

  - card
  - card_token
  - customer_token

  ## Error handling

  All requests return tagged tuples in the form `{:ok, result}` or `{:error, %PINXS.Error{}}`

  """

  @derive [Poison.Encoder]
  defstruct [
    :amount_refunded,
    :amount,
    :authorisation_expired,
    :capture,
    :captured,
    :card_token,
    :card,
    :customer_token,
    :description,
    :email,
    :ip_address,
    :merchant_entitlement,
    :metadata,
    :refund_pending,
    :settlement_currency,
    :total_fees,
    :token,
    :transfer,
    currency: "AUD"
  ]

  @type t :: %__MODULE__{
          amount_refunded: nil | integer(),
          amount: nil | integer(),
          authorisation_expired: nil | boolean(),
          capture: nil | boolean(),
          captured: nil | boolean(),
          card_token: nil | String.t(),
          card: nil | PINXS.Cards.Card.t(),
          currency: nil | String.t(),
          customer_token: nil | String.t(),
          description: nil | String.t(),
          email: nil | String.t(),
          ip_address: nil | String.t(),
          merchant_entitlement: nil | integer(),
          metadata: nil | map(),
          refund_pending: nil | boolean(),
          settlement_currency: nil | String.t(),
          total_fees: nil | integer(),
          token: nil | String.t(),
          transfer: nil | list()
        }
  @doc """
  Captures a previously authorized charge
  """
  @spec capture(Charge.t(), PINXS.t()) :: {:ok, Charge.t()} | {:error, PINXS.Error.t()}
  def capture(%Charge{} = charge, %PINXS{} =  config) do
    capture(charge, %{}, config)
  end

  @spec capture(Charge.t(), map(), PINXS.t()) :: {:ok, Charge.t()} | {:error, PINXS.Error.t()}
  def capture(%Charge{token: token}, amount, %PINXS{} = config) do
    API.put("/charges/#{token}/capture", amount, __MODULE__, config)
  end

  @doc """
  Creates a new charge and returns its details

  The `Charge` struct must have one of the following fields, `card`, `card_token` or `customer_token`


  """
  @spec create(Charge.t(), PINXS.t()) :: {:ok, Charge.t()} | {:error, PINXS.Error.t()}
  def create(%Charge{card: card} = charge_map, %PINXS{} = config) when not is_nil(card),
    do: create_charge(charge_map, config)

  def create(%Charge{card_token: card_token} = charge_map, config) when not is_nil(card_token),
    do: create_charge(charge_map, config)

  def create(%Charge{customer_token: customer_token} = charge_map, config)
      when not is_nil(customer_token),
      do: create_charge(charge_map, config)

  defp create_charge(charge_map, config) do
    API.post("/charges", charge_map, __MODULE__, config)
  end

  @doc """
  Retrieves a paginated list of charges
  """
  @spec get_all(PINXS.t()) :: {:ok, [Charge.t()]} | {:error, PINXS.Error.t}
  def get_all(%PINXS{} = config) do
    API.get("/charges", __MODULE__, config)
  end

  @doc """
  Retrieves a specific pages of charges
  """
  @spec get_all(integer(), PINXS.t()) :: {:ok, [Charge.t()]} | {:error, PINXS.Error.t}
  def get_all(page, %PINXS{} = config) do
    API.get("/charges?page=#{page}", __MODULE__, config)
  end

  @doc """
  Retrieves a single charge
  """
  @spec get(String.t(), PINXS.t()) :: {:ok, Charge.t()} | {:error, PINXS.Error.t()}
  def get(token, %PINXS{} = config) do
    API.get("/charges/#{token}", __MODULE__, config)
  end

  @doc """
  Retrieve charges based on search criteria

  ## Search options
  ```
  %{
    query: "",
    start_date: "YYYY/MM/DD", # 2013/01/01
    end_date: "YYYY/MM/DD", # 2013/12/25
    sort: "", # field to sort by, default `created_at`
    direction: 1 # 1 or -1
  }
  ```
  """

  @spec search(map(), PINXS.t()) :: {:ok, map()} | {:error, PINXS.Error.t()}
  def search(query_map, %PINXS{} =  config) do
    API.search("/charges/search", query_map, __MODULE__, config)
  end
end
