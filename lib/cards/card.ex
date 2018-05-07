defmodule PinPayments.Cards.Card do
  alias PinPayments.Cards.Card
  alias PinPayments.HTTP.PinApi

  import PinApi
  import PinPayments.HTTP.Response

  @derive Jason.Encoder
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
    post("/cards", card_map)
    |> normalize
  end
end
