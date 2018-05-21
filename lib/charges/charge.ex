defmodule PinPayments.Charges.Charge do
  alias PinPayments.HTTP.API
  alias __MODULE__

  @derive [Poison.Encoder]
  defstruct [
    :email,
    :description,
    :amount,
    :ip_address,
    :currency,
    :capture,
    :metadata,
    :card,
    :card_token,
    :customer_token,
    :transfer,
    :amount_refunded,
    :total_fees,
    :merchant_entitlement,
    :refund_pending,
    :authorisation_expired,
    :captured,
    :settlement_currency,
    :metadata
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
  def create(%Charge{card: card} = charge_map) when not is_nil(card), do: create_charge(charge_map)

  def create(%Charge{card_token: card_token} = charge_map) when not is_nil(card_token), do: create_charge(charge_map)

  def create(%Charge{customer_token: customer_token} = charge_map) when not is_nil(customer_token), do: create_charge(charge_map)

  defp create_charge(charge_map) do
    API.post("/charges", charge_map)
    |> handle_response
  end

  defp handle_response({:ok, response}) do
    {:ok, struct(%__MODULE__{}, response.body.response)}
  end
  defp handle_response(response), do: response

end
