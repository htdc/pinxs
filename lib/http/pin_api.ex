defmodule PinPayments.HTTP.PinApi do
  use Tesla
  adapter :hackney, pool: :pin_api

  alias PinPayments.Cards.Card
  alias PinPayments.Charges.Charge


  @pin_url Application.get_env(:pin_payments, :pin_url)
  @pin_api_key Application.get_env(:pin_payments, :api_key)

  plug(Tesla.Middleware.BaseUrl, @pin_url)
  plug(Tesla.Middleware.BasicAuth, username: @pin_api_key)
  plug(Tesla.Middleware.Tuples)
  plug(Tesla.Middleware.JSON, engine: Jason)

  def balance() do
    get("/balance")
  end

  def create_card(%Card{} = card_map) do
    post("/cards", card_map)
  end

  def create_charge(%Charge{} = charge_map) do
    post("/charges", charge_map)
  end

end
