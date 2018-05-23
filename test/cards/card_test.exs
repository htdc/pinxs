defmodule PinPayments.Cards.CardTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PinPayments.Cards.Card

  test "Create a card" do
    card = %Card{
      number: "5520000000000000",
      expiry_month: "12",
      expiry_year: "20",
      name: "Rubius Hagrid",
      address_line1: "The Game Keepers Cottage",
      address_city: "Hogwarts",
      address_country: "England",
      cvc: "321"
    }

    use_cassette("cards") do
      {:ok, response} = Card.create(card)

      assert response.expiry_year == 2020
    end
  end

  test "With missing required field" do
    card = %Card{
      number: "4444444444444444",
      expiry_month: "12",
      expiry_year: "20",
      name: "Rubius Hagrid",
      address_line1: "The Game Keepers Cottage",
      cvc: "321"
    }

    use_cassette("card_with_missing_field") do
      {:error, response} = Card.create(card)

      assert response.error_description == "One or more parameters were missing or invalid"
    end
  end
end
