defmodule PinPayments.Cards.Card do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
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
    :number,
    :token
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

  def create(%Card{} = card) do
    API.post("/cards", card)
    |> Response.transform(__MODULE__)
  end

end
