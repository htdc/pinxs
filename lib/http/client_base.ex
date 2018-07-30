defmodule PINXS.HTTP.ClientBase do
  @moduledoc false
  use HTTPoison.Base

  @pin_url Application.get_env(:pinxs, :pin_url, "https://test-api.pin.net.au/1")

  def authenticated_delete(url, config) do
    delete(url, transform_config(config), []) |> normalize()
  end

  def authenticated_get(url, config) do
    get(url, transform_config(config), []) |> normalize()
  end

  def authenticated_post(url, params, config) do
    post(url, params, transform_config(config)) |> normalize()
  end

  def authenticated_put(url, params, config) do
    put(url, params, transform_config(config)) |> normalize()
  end

  def authenticated_search(url, body, config) do
    request(:get, url, body, transform_config(config)) |> normalize()
  end

  def process_url(endpoint) do
    @pin_url <> endpoint
  end

  def process_request_headers(headers) when is_list(headers), do: headers
  def process_request_headers(_), do: raise("Api Key not provided")

  def process_response_body(""), do: ""
  def process_response_body(body), do: Poison.decode!(body, keys: :atoms)
  def process_request_body(body), do: Poison.encode!(body)

  defp transform_config(%PINXS{api_key: api_key}) do
    encoded = Base.encode64(api_key)

    [{"Authorization", "Basic #{encoded}"}, {"Content-Type", "application/json"}]
    |> process_request_headers
  end

  def normalize({:ok, %{status_code: status_code} = response}) when status_code in 200..299,
    do: {:ok, response}

  def normalize({:ok, response}), do: {:error, response}
  def normalize(any), do: any
end
