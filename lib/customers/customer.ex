defmodule PINXS.Customers.Customer do
  alias PINXS.HTTP.API
  alias PINXS.Cards.Card
  alias __MODULE__

  @moduledoc """
  Provides functions for working with customers

  ## Required Fields

  When creating a Customer, the following fields must be provided

  - email

  and one of

  - card
  - card_token
  """

  @derive Poison.Encoder
  defstruct [
    :email,
    :card,
    :card_token,
    :token
  ]

  @type t :: %__MODULE__{
          email: String.t(),
          card: nil | PINXS.Cards.Card.t(),
          card_token: nil | String.t(),
          token: nil | String.t()
        }

  @doc """
  Adds a card to a customer
  """
  def add_card(%Customer{token: token}, %Card{} = card, %PINXS{} = config) do
    API.post("/customers/#{token}/cards", card, Card, config)
  end

  def add_card(%Customer{token: token}, card_token, %PINXS{} = config)
      when is_binary(card_token) do
    API.post("/customers/#{token}/cards", %{card_token: card_token}, Card, config)
  end

  @doc """
  Creates a customer
  """
  def create(%Customer{card: card} = customer, %PINXS{} = config) when not is_nil(card),
    do: create_customer(customer, config)

  def create(%Customer{card_token: card_token} = customer, %PINXS{} = config)
      when not is_nil(card_token),
      do: create_customer(customer, config)

  defp create_customer(customer, %PINXS{} = config) do
    API.post("/customers", customer, __MODULE__, config)
  end

  @doc """
  Deletes a customer
  """
  def delete(%Customer{token: token}, %PINXS{} = config) do
    API.delete("/customers/#{token}", __MODULE__, config)
  end

  @doc """
  Deletes a card belonging to a customer
  """
  def delete_card(%Customer{token: token}, card_token, %PINXS{} = config) do
    API.delete("/customers/#{token}/cards/#{card_token}", __MODULE__, config)
  end

  @doc """
  Retreives a customer
  """
  def get(token, %PINXS{} = config) do
    API.get("/customers/#{token}", __MODULE__, config)
  end

  @doc """
  Retrieves a paginated list of customers
  """
  def get_all(%PINXS{} = config) do
    API.get("/customers", __MODULE__, config)
  end

  @doc """
  Retreives a specific page of customers
  """
  def get_all(page, %PINXS{} = config) when is_integer(page) do
    API.get("/customers?page=#{page}", __MODULE__, config)
  end

  @doc """
  Retrieves all cards for the given customer
  """
  def get_cards(%Customer{token: token}, %PINXS{} = config) do
    API.get("/customers/#{token}/cards", Card, config)
  end

  @doc """
  Retrieves all charges for customer
  """
  def get_charges(%Customer{token: token}, %PINXS{} = config) do
    API.get("/customers/#{token}/charges", PINXS.Charges.Charge, config)
  end

  # TODO Add 'Subscriptions'

  @doc """
  Updates a customer
  """
  def update(%Customer{token: token}, params, %PINXS{} = config) when not is_nil(token) do
    API.put("/customers/#{token}", params, __MODULE__, config)
  end
end
