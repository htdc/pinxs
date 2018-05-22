defmodule PinPayments.Customers.Customer do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
  alias PinPayments.Cards.Card
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
          card: nil | PinPayments.Cards.Card.t(),
          card_token: nil | String.t(),
          token: nil | String.t()
        }

  @doc """
  Adds a card to a customer
  """
  @spec add_card(Customer.t(), Card.t()) :: {:ok, Card.t()} | {:error, PinPayments.Error.t()}
  def add_card(%Customer{token: token}, %Card{} = card) do
    API.post("/customers/#{token}/cards", card)
    |> Response.transform(Card)
  end

  def add_card(%Customer{token: token}, card_token) when is_binary(card_token) do
    API.post("/customers/#{token}/cards", %{card_token: card_token})
    |> Response.transform(Card)
  end

  @doc """
  Creates a customer
  """
  @spec create(Customer.t()) :: {:ok, Customer.t()} | {:error | PinPayments.Error.t()}
  def create(%Customer{card: card} = customer) when not is_nil(card),
    do: create_customer(customer)

  def create(%Customer{card_token: card_token} = customer) when not is_nil(card_token),
    do: create_customer(customer)

  defp create_customer(customer) do
    API.post("/customers", customer)
    |> Response.transform(__MODULE__)
  end

  @doc """
  Deletes a customer
  """
  @spec delete(Customer.t()) :: {:ok, true} | {:error, PinPayments.Error.t()}
  def delete(%Customer{token: token}) do
    API.delete("/customers/#{token}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Deletes a card belonging to a customer
  """
  @spec delete_card(Customer.t(), String.t()) ::
          {:ok, Customer.t()} | {:error, PinPayments.Error.t()}
  def delete_card(%Customer{token: token}, card_token) do
    API.delete("/customers/#{token}/cards/#{card_token}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Retreives a customer
  """
  @spec get(String.t()) :: {:ok, Customer.t()} | {:error, PinPayments.Error.t()}
  def get(token) do
    API.get("/customers/#{token}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Retrieves a paginated list of customers
  """
  @spec get_all() :: {:ok, [Customer.t()]} | {:error, PinPayments.Error.t()}
  def get_all() do
    API.get("/customers")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Retreives a specific page of customers
  """
  @spec get_all(Integer.t()) :: {:ok, [Customer.t()]} | {:error, PinPayments.Error.t()}
  def get_all(page) when is_integer(page) do
    API.get("/customers?page=#{page}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Retrieves all cards for the given customer
  """
  @spec get_cards(Customer.t()) :: {:ok, [Card.t()]} | {:error, PinPayments.Error.t()}
  def get_cards(%Customer{token: token}) do
    API.get("/customers/#{token}/cards")
    |> Response.transform(Card)
  end

  @doc """
  Retrieves all charges for customer
  """
  @spec get_charges(Customer.t()) :: {:ok, [Charge.t()]} | {:error, PinPayments.Error.t()}
  def get_charges(%Customer{token: token}) do
    API.get("/customers/#{token}/charges")
    |> Response.transform(PinPayments.Charges.Charge)
  end

  # TODO Add 'Subscriptions'

  @doc """
  Updates a customer
  """
  @spec update(Customer.t(), map()) :: {:ok, Customer.t()} | {:error, PinPayments.Error.t()}
  def update(%Customer{token: token}, params) when not is_nil(token) do
    API.put("/customers/#{token}", params)
    |> Response.transform(__MODULE__)
  end
end
