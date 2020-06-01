defmodule PINXS.Cards.Card do
  alias PINXS.HTTP.API
  alias __MODULE__

  @moduledoc """
  Provides functions for working with cards

  ## Required Fields

  When creating a card, the following fields much be provided

  - number
  - expiry_month
  - expiry_year
  - cvc
  - name
  - address_line1
  - address_country

  """

  @derive [Poison.Encoder, Jason.Encoder]
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

  @type t :: %__MODULE__{
          address_city: nil | String.t(),
          address_country: String.t(),
          address_line1: String.t(),
          address_line2: nil | String.t(),
          address_postcode: nil | String.t(),
          address_state: nil | String.t(),
          cvc: String.t(),
          expiry_month: String.t(),
          expiry_year: String.t(),
          name: String.t(),
          number: String.t(),
          token: nil | String.t()
        }

  @doc """
  Creates a tokenized credit card
  """
  def create(%Card{} = card, config) do
    API.post("/cards", card, __MODULE__, config)
  end
end
