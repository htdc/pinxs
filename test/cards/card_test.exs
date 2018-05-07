defmodule PinPayments.Cards.CardTest do
  use ExUnit.Case
  alias PinPayments.Cards.Card

  setup do
    Tesla.Mock.mock(fn %{method: :post, url: "https://test-api.pin.net.au/1/cards"} ->
      Tesla.Mock.json(
        %{
          "ip_address" => "120.16.38.114",
          "response" => %{
            "address_city" => "Hogwarts",
            "address_country" => "England",
            "address_line1" => "The Game Keepers Cottage",
            "address_line2" => nil,
            "address_postcode" => nil,
            "address_state" => nil,
            "customer_token" => nil,
            "display_number" => "XXXX-XXXX-XXXX-0000",
            "expiry_month" => 12,
            "expiry_year" => 2020,
            "name" => "Rubius Hagrid",
            "primary" => nil,
            "scheme" => "master",
            "token" => "card_OVkOdvXQTGyv12Z3KhRNYw"
          }
        },
        status: 200
      )
    end)

    :ok
  end

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

    Card.create(card)
    {:ok, %{body: %{"response" => response}}} = Card.create(card)

    assert response["expiry_year"] == 2020
  end

  test "With missing required field" do
    Tesla.Mock.mock(fn %{method: :post, url: "https://test-api.pin.net.au/1/cards"} ->
      Tesla.Mock.json(
        %{
          "error" => "invalid_resource",
          "error_description" => "One or more parameters were missing or invalid",
          "messages" => [
            %{
              "code" => "address_country_invalid",
              "message" => "Address country can't be blank",
              "param" => "address_country"
            }
          ]
        },
        status: 422
      )
    end)

    card = %Card{
      number: "4444444444444444",
      expiry_month: "12",
      expiry_year: "20",
      name: "Rubius Hagrid",
      address_line1: "The Game Keepers Cottage",
      cvc: "321"
    }

    {:error, %{body: error_response}} = Card.create(card)

    assert error_response["error_description"] == "One or more parameters were missing or invalid"
  end
end
