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

  @derive [Jason.Encoder]
  defstruct [
    :active_chargebacks,
    :amount_refunded,
    :amount,
    :authorisation_expired,
    :authorisation_token,
    :authorisation_voided,
    :capture,
    :captured,
    :captured_at,
    :card_token,
    :card,
    :customer_token,
    :description,
    :email,
    :error_message,
    :ip_address,
    :merchant_entitlement,
    :metadata,
    :refund_pending,
    :settlement_currency,
    :status_message,
    :success,
    :total_fees,
    :token,
    :transfer,
    currency: "AUD"
  ]

  @type t :: %__MODULE__{
          active_chargebacks: nil | boolean(),
          amount_refunded: nil | integer(),
          amount: nil | integer(),
          authorisation_expired: nil | boolean(),
          authorisation_token: nil | String.t(),
          authorisation_voided: nil | boolean(),
          capture: nil | boolean(),
          captured: nil | boolean(),
          captured_at: nil | String.t(),
          card_token: nil | String.t(),
          card: nil | PINXS.Cards.Card.t(),
          currency: nil | String.t(),
          customer_token: nil | String.t(),
          description: nil | String.t(),
          email: nil | String.t(),
          error_message: nil | String.t(),
          ip_address: nil | String.t(),
          merchant_entitlement: nil | integer(),
          metadata: nil | map(),
          refund_pending: nil | boolean(),
          settlement_currency: nil | String.t(),
          status_message: nil | String.t(),
          success: nil | boolean(),
          total_fees: nil | integer(),
          token: nil | String.t(),
          transfer: nil | list()
        }
  @doc """
  Captures a previously authorized charge
  """
  def capture(%Charge{} = charge, config) do
    capture(charge, %{}, config)
  end

  def capture(%Charge{token: token}, amount, config) do
    API.put("/charges/#{token}/capture", amount, __MODULE__, config)
  end

  @doc """
  Creates a new charge and returns its details

  The `Charge` struct must have one of the following fields, `card`, `card_token` or `customer_token`


  """
  def create(%Charge{card: card} = charge_map, config) when not is_nil(card),
    do: create_charge(charge_map, config)

  def create(%Charge{card_token: card_token} = charge_map, config)
      when not is_nil(card_token),
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
  def get_all(config) do
    API.get("/charges", __MODULE__, config)
  end

  @doc """
  Retrieves a specific pages of charges
  """
  def get_all(page, config) do
    API.get("/charges?page=#{page}", __MODULE__, config)
  end

  @doc """
  Retrieves a single charge
  """
  def get(token, config) when is_binary(token) do
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

  def search(query_map, config) do
    API.search("/charges/search", query_map, __MODULE__, config)
  end

  @doc """
  Voids a pre-authorized charge without claiming funds
  """
  def void(token, config) do
    API.put("/charges/#{token}/void", %{}, __MODULE__, config)
  end
end
