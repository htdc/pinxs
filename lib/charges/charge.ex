defmodule PinPayments.Charges.Charge do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
  alias __MODULE__

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
    :transfer,
  ]

  @moduledoc """
  # Required Fields

  - email
  - description
  - amount
  - ip_address

  and one of
  - card
  - card_token
  - customer_token

  # Optional Fields

  - currency
  - capture
  - metadata

  """
  def capture(%Charge{token: token}, amount \\ %{}) do
    API.put("/charges/#{token}/capture", amount)
    |> Response.transform(__MODULE__)
  end

  def create(%Charge{card: card} = charge_map) when not is_nil(card), do: create_charge(charge_map)

  def create(%Charge{card_token: card_token} = charge_map) when not is_nil(card_token), do: create_charge(charge_map)

  def create(%Charge{customer_token: customer_token} = charge_map) when not is_nil(customer_token), do: create_charge(charge_map)

  defp create_charge(charge_map) do
    API.post("/charges", charge_map)
    |> Response.transform(__MODULE__)
  end

  def get_all() do
    API.get("/charges")
    |> Response.transform(__MODULE__)
  end

  def get_all(page) do
    API.get("/charges?page=#{page}")
    |> Response.transform(__MODULE__)
  end

  def get(token) do
    API.get("/charges/#{token}")
    |> Response.transform(__MODULE__)
  end
end
