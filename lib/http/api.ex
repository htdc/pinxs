defmodule PINXS.HTTP.API do
  alias PINXS.HTTP.ClientBase, as: Client
  alias PINXS.HTTP.Response

  @moduledoc """
  The API module provides low level functions for communicating with
  the Pin Payments server.

  It is not expected that you would commonly use these functions, but they
  are available where extreme customisation is desired
  """

  def delete(url, %PINXS{} = config), do: Client.authenticated_delete(url, config)
  def delete(url, %Tesla.Client{} = client), do: Tesla.delete(client, url)

  def delete(url, module, %PINXS{} = config),
    do: delete(url, config) |> Response.transform(module)

  def delete(url, module, %Tesla.Client{} = client),
    do: Tesla.delete(client, url) |> Response.transform(module)

  def get(url, %PINXS{} = config), do: Client.authenticated_get(url, config)
  def get(url, %Tesla.Client{} = client), do: Tesla.get(client, url)

  def get(url, module, %PINXS{} = config),
    do: Client.authenticated_get(url, config) |> Response.transform(module)

  def get(url, module, %Tesla.Client{} = client),
    do: Tesla.get(client, url) |> Response.transform(module)

  def search(url, params, module, %PINXS{} = config),
    do: Client.authenticated_search(url, params, config) |> Response.transform(module)

  def search(url, params, module, %Tesla.Client{} = client),
    do: Tesla.get(client, url, query: params) |> Response.transform(module)

  def post(url, params, %PINXS{} = config), do: Client.authenticated_post(url, params, config)

  def post(url, params, %Tesla.Client{} = client), do: Tesla.post(client, url, params)

  def post(url, params, module, %PINXS{} = config),
    do: post(url, params, config) |> Response.transform(module)

  def post(url, params, module, %Tesla.Client{} = client),
    do: post(url, params, client) |> Response.transform(module)

  def put(url, params, %PINXS{} = config), do: Client.authenticated_put(url, params, config)
  def put(url, params, %Tesla.Client{} = client), do: Tesla.put(client, url, params)

  def put(url, params, module, %PINXS{} = config),
    do: put(url, params, config) |> Response.transform(module)

  def put(url, params, module, %Tesla.Client{} = client),
    do: put(url, params, client) |> Response.transform(module)
end
