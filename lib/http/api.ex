defmodule PinPayments.HTTP.API do
  alias PinPayments.HTTP.ClientBase, as: Client

  @moduledoc """
  The API module provides low level functions for communicating with
  the Pin Payments server.

  It is not expected that you would commonly use these functions, but they
  are available where extreme customisation is desired
  """

  def delete(url), do: Client.delete(url)
  def get(url), do: Client.get(url)
  def post(url, params), do: Client.post(url, params)
  def put(url, params), do: Client.put(url, params)
end
