defmodule PinPayments.Customers.Customer do
  alias PinPayments.HTTP.API
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
    |> handle_response
  end

  defp handle_response({:ok, response}) do
    {:ok, struct(%__MODULE__{}, response.body.response)}
  end

  defp handle_response(response), do: response
end
