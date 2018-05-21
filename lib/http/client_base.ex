defmodule PinPayments.HTTP.ClientBase do
  use HTTPoison.Base

  @pin_url Application.get_env(:pin_payments, :pin_url)
  @pin_api_key Application.get_env(:pin_payments, :api_key)
  @encoded Base.encode64("#{@pin_api_key}:")

  # plug(Tesla.Middleware.JSON, engine: Poison)

  def process_url(endpoint) do
    @pin_url <> endpoint
  end

  def process_request_headers(_headers) do
    [{"Authorization", "Basic #{@encoded}"}, {"Content-Type", "application/json"}  ]
  end

  def process_response_body(body), do: Poison.decode!(body, keys: :atoms)
  def process_request_body(body), do: Poison.encode!(body)

  def get(url, headers \\ [], options \\ []),
    do: request(:get, url, "", headers, options) |> normalize()

  def post(url, body, headers \\ [], options \\ []),
    do: request(:post, url, body, headers, options) |> normalize()

  def put(url, body \\ "", headers \\ [], options \\ []),
    do: request(:put, url, body, headers, options) |> normalize()

  def normalize({:ok, %{status_code: status_code} = response}) when status_code in 200..299,
    do: {:ok, response}

  def normalize({:ok, response}), do: {:error, response}
  def normalize(any), do: any
end
