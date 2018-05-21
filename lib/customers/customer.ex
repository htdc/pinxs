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

end
