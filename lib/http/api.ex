defmodule PinPayments.HTTP.API do
  alias PinPayments.HTTP.ClientBase, as: Client

  def delete(url), do: Client.delete(url)
  def get(url), do: Client.get(url)
  def post(url, params), do: Client.post(url, params)
  def put(url, params), do: Client.put(url, params)
end
