defmodule PinPayments.Customers.Customer do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
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

  def create(%Customer{card: card} = customer) when not is_nil(card), do: create_customer(customer)
  def create(%Customer{card_token: card_token} = customer) when not is_nil(card_token), do: create_customer(customer)

  defp create_customer(customer) do
    API.post("/customers", customer)
    |> Response.transform(__MODULE__)
  end

  def get(customer_token) do
    API.get("/customers/#{customer_token}")
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
    |> Response.transform(PinPayments.Cards.Card)
  end


  def get_charges(%Customer{token: token}) do
    API.get("/customers/#{token}/charges")
    |> Response.transform(PinPayments.Charges.Charge)
  end

  def update(%Customer{token: customer_token}, params) when not is_nil(customer_token) do
    API.put("/customers/#{customer_token}", params)
    |> Response.transform(__MODULE__)
  end

  def delete(%Customer{token: customer_token}) do
    API.delete("/customers/#{customer_token}")
    |> Response.transform(__MODULE__)
  end
end
