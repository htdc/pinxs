defmodule PinPayments.HTTP.API do
  alias PinPayments.HTTP.ClientBase, as: Client

  def get(url), do: Client.get(url)
  def post(url, params), do: Client.post(url, params)

end
