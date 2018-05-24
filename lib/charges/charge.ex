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
    :currency,
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
    :transfer
  ]

  @type t :: %__MODULE__{
          amount_refunded: nil | integer(),
          amount: nil | integer(),
          authorisation_expired: nil | boolean(),
          capture: nil | boolean(),
          captured: nil | boolean(),
          card_token: nil | String.t(),
          card: nil | PINXS.Cards.Card.t(),
          currency: String.t(),
          customer_token: nil | String.t(),
          description: String.t(),
          email: String.t(),
          ip_address: String.t(),
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
  def capture(%Charge{token: token}, amount \\ %{}) do
    API.put("/charges/#{token}/capture", amount, __MODULE__)
  end

  @doc """
  Creates a new charge and returns its details

  The `Charge` struct must have one of the following fields, `card`, `card_token` or `customer_token`


  """
  @spec create(Charge.t) :: {:ok, Charge.t} | {:error, PINXS.Error.t()}
  def create(%Charge{card: card} = charge_map) when not is_nil(card),
    do: create_charge(charge_map)

  def create(%Charge{card_token: card_token} = charge_map) when not is_nil(card_token),
    do: create_charge(charge_map)

  def create(%Charge{customer_token: customer_token} = charge_map)
      when not is_nil(customer_token),
      do: create_charge(charge_map)

  defp create_charge(charge_map) do
    API.post("/charges", charge_map, __MODULE__)
  end

  @doc """
  Retrieves a paginated list of charges
  """
  @spec get_all() :: {:ok, [Charge.t]} | {:error, PINXS.Error.t}
  def get_all() do
    API.get("/charges", __MODULE__)
  end

  @doc """
  Retrieves a specific pages of charges
  """
  @spec get_all(integer()) :: {:ok, [Charge.t]} | {:error, PINXS.Error.t}
  def get_all(page) do
    API.get("/charges?page=#{page}", __MODULE__)
  end

  @doc """
  Retrieves a single charge
  """
  @spec get(String.t()) :: {:ok, Charge.t} | {:error, PINXS.Error.t()}
  def get(token) do
    API.get("/charges/#{token}", __MODULE__)
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

  @spec search(map()) :: {:ok, [Charge.t]} | {:error, PINXS.Error.t()}
  def search(query_map) do
    API.search("/charges/search", query_map, __MODULE__)
  end
end
