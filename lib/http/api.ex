defmodule PINXS.HTTP.API do
  alias PINXS.HTTP.ClientBase, as: Client
  alias PINXS.Response

  @moduledoc """
  The API module provides low level functions for communicating with
  the Pin Payments server.

  It is not expected that you would commonly use these functions, but they
  are available where extreme customisation is desired
  """

  def delete(url), do: Client.delete(url)
  def delete(url, module), do: delete(url) |> Response.transform(module)
  def get(url), do: Client.get(url)
  def get(url, module), do: get(url) |> Response.transform(module)
  def post(url, params), do: Client.post(url, params)
  def post(url, params, module), do: post(url, params) |> Response.transform(module)
  def put(url, params), do: Client.put(url, params)
  def put(url, params, module), do: put(url, params) |> Response.transform(module)
end
