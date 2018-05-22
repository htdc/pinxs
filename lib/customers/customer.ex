defmodule PinPayments.Customers.Customer do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
  alias PinPayments.Cards.Card
  alias __MODULE__

  @derive Poison.Encoder
  defstruct [
    :email,
    :card,
    :card_token,
    :token
  ]

  @moduledoc """
  # Required Fields

  - email

  and one of

  - card
  - card_token
  """

  def add_card(%Customer{token: token}, %Card{} = card) do
    API.post("/customers/#{token}/cards", card)
    |> Response.transform(Card)
  end

  def add_card(%Customer{token: token}, card_token) when is_binary(card_token) do
    API.post("/customers/#{token}/cards", %{card_token: card_token})
    |> Response.transform(Card)
  end

  def create(%Customer{card: card} = customer) when not is_nil(card), do: create_customer(customer)
  def create(%Customer{card_token: card_token} = customer) when not is_nil(card_token), do: create_customer(customer)

  defp create_customer(customer) do
    API.post("/customers", customer)
    |> Response.transform(__MODULE__)
  end

  def delete(%Customer{token: token}) do
    API.delete("/customers/#{token}")
    |> Response.transform(__MODULE__)
  end

  def delete_card(%Customer{token: token}, card_token) do
    API.delete("/customers/#{token}/cards/#{card_token}")
    |> Response.transform(__MODULE__)
  end

  def get(token) do
    API.get("/customers/#{token}")
    |> Response.transform(__MODULE__)
  end

  def get_all() do
    API.get("/customers")
    |> Response.transform(__MODULE__)
  end

  def get_all(page) when is_integer(page) do
    API.get("/customers?page=#{page}")
    |> Response.transform(__MODULE__)
  end

  def get_cards(%Customer{token: token}) do
    API.get("/customers/#{token}/cards")
    |> Response.transform(Card)
  end

  def get_charges(%Customer{token: token}) do
    API.get("/customers/#{token}/charges")
    |> Response.transform(PinPayments.Charges.Charge)
  end

  # TODO Add 'Subscriptions'

  def update(%Customer{token: token}, params) when not is_nil(token) do
    API.put("/customers/#{token}", params)
    |> Response.transform(__MODULE__)
  end
end
