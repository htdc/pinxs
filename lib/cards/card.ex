defmodule PinPayments.Cards.Card do
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

  - address_line1
  - address_postcode
  - address_state
  """
end
