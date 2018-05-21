defmodule PinPayments.Cards.Card do
  alias PinPayments.HTTP.API
  alias __MODULE__

  @derive Poison.Encoder
  defstruct [
    :address_city,
    :address_country,
    :address_line1,
    :address_line2,
    :address_postcode,
    :address_state,
    :cvc,
    :expiry_month,
    :expiry_year,
    :name,
    :number
  ]

  @moduledoc """
  # Required Fields

  - number
  - expiry_month
  - expiry_year
  - cvc
  - name
  - address_line1
  - address_country

  # Optional Fields

  - address_city
  - address_line1
  - address_postcode
  - address_state
  """

  def create(%Card{} = card_map) do
    API.post("/cards", card_map)
    |> handle_response
  end

  defp handle_response({:ok, response}) do
    {:ok, struct(%__MODULE__{}, response.body.response)}
  end

  defp handle_response(response), do: response

end
