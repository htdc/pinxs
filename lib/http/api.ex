defmodule PINXS.HTTP.API do
  alias PINXS.HTTP.ClientBase, as: Client
  alias PINXS.HTTP.Response

  @moduledoc """
  The API module provides low level functions for communicating with
  the Pin Payments server.

  It is not expected that you would commonly use these functions, but they
  are available where extreme customisation is desired
  """

  def delete(url, config), do: Client.authenticated_delete(url, config)
  def delete(url, module, config), do: delete(url, config) |> Response.transform(module)
  def get(url, config), do: Client.authenticated_get(url, config)
  def get(url, module, config), do: Client.authenticated_get(url, config) |> Response.transform(module)

  def search(url, params, module, config),
    do: Client.authenticated_search(url, params, config) |> Response.transform(module)

  def post(url, params, config), do: Client.authenticated_post(url, params, config)

  def post(url, params, module, config),
    do: post(url, params, config) |> Response.transform(module)

  def put(url, params, config), do: Client.authenticated_put(url, params, config)
  def put(url, params, module, config), do: put(url, params, config) |> Response.transform(module)
end
