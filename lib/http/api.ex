defmodule PINXS.HTTP.API do
  alias PINXS.HTTP.Response

  @moduledoc """
  The API module provides low level functions for communicating with
  the Pin Payments server.

  It is not expected that you would commonly use these functions, but they
  are available where extreme customisation is desired
  """

  def delete(url, %Tesla.Client{} = client), do: Tesla.delete(client, url)

  def delete(url, module, %Tesla.Client{} = client),
    do: Tesla.delete(client, url) |> Response.transform(module)

  def get(url, %Tesla.Client{} = client), do: Tesla.get(client, url)

  def get(url, module, %Tesla.Client{} = client),
    do: Tesla.get(client, url) |> Response.transform(module)

  def search(url, params, module, %Tesla.Client{} = client),
    do: Tesla.get(client, url, query: params) |> Response.transform(module)

  def post(url, params, %Tesla.Client{} = client), do: Tesla.post(client, url, params)

  def post(url, params, module, %Tesla.Client{} = client),
    do: post(url, params, client) |> Response.transform(module)

  def put(url, params, %Tesla.Client{} = client), do: Tesla.put(client, url, params)

  def put(url, params, module, %Tesla.Client{} = client),
    do: put(url, params, client) |> Response.transform(module)
end
