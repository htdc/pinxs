defmodule PINXS.Cards.CardTest do
  use ExUnit.Case, async: true

  alias PINXS.Cards.Card
  use Nug
  import PINXS.TestHelpers

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

    with_proxy(PINXS.Client.test_url(), "test/fixtures/cards.fixture") do
      {:ok, response} = Card.create(card, client(address))

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

    with_proxy(PINXS.Client.test_url(), "test/fixtures/card_with_missing_field.fixture") do
      {:error, response} = Card.create(card, client(address))

      assert response.error_description == "One or more parameters were missing or invalid"
    end
  end
end
