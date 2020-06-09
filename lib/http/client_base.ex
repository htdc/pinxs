defmodule PINXS.HTTP.ClientBase do
  @moduledoc false
  use HTTPoison.Base

  def pin_url(path, %PINXS{url: base_url}) do
    base_url <> path
  end

  @deprecated "Using the HTTPoison client is deprecated, and will be removed in 3.x, please use PINXS.Client instead"
  def authenticated_delete(url, config) do
    delete(pin_url(url, config), transform_config(config), []) |> normalize()
  end

  @deprecated "Using the HTTPoison client is deprecated, and will be removed in 3.x, please use PINXS.Client instead"
  def authenticated_get(url, config) do
    get(pin_url(url, config), transform_config(config), []) |> normalize()
  end

  @deprecated "Using the HTTPoison client is deprecated, and will be removed in 3.x, please use PINXS.Client instead"
  def authenticated_post(url, params, config) do
    post(pin_url(url, config), params, transform_config(config)) |> normalize()
  end

  @deprecated "Using the HTTPoison client is deprecated, and will be removed in 3.x, please use PINXS.Client instead"
  def authenticated_put(url, params, config) do
    put(pin_url(url, config), params, transform_config(config)) |> normalize()
  end

  @deprecated "Using the HTTPoison client is deprecated, and will be removed in 3.x, please use PINXS.Client instead"
  def authenticated_search(url, body, config) do
    request(:get, pin_url(url, config), body, transform_config(config)) |> normalize()
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
