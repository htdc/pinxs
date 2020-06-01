defmodule PINXS.Client do
  @moduledoc """
  Used for building a Tesla client for use with the Spreedly API
  """

  @doc """
  Create a new `Tesla.Client`
  ## Parameters
  - `secrets` is [`%PINXS{}`](`PINXS`) struct
  """
  def new(%PINXS{} = secrets) do
    new(secrets, default_url(), default_adapter())
  end

  @doc """
  Create a new `Tesla.Client`
  ## Parameters
  - `secrets` is [`%PINXS{}`](`PINXS`) struct
  - `url` allows you to override the URL where requests will be sent.  Useful for testing
  """
  def new(%PINXS{} = secrets, url) do
    new(secrets, url, default_adapter())
  end

  @doc """
  Create a new `Tesla.Client`
  ## Parameters
  - `secrets` is [`%PINXS{}`](`PINXS`) struct
  - `url` allows you to override the URL where requests will be sent.  Useful for testing
  - `adapter` Allows you to use a different `Tesla.Adapter` to the default which is `Tesla.Adapter.Gun`
  """
  def new(%PINXS{} = secrets, url, adapter) do
    middleware = [
      Tesla.Middleware.Query,
      {Tesla.Middleware.BasicAuth, [username: secrets.api_key]},
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.KeepRequest,
      Tesla.Middleware.Compression,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.JSON, [engine_opts: [keys: :atoms]]}
    ]

    Tesla.client(middleware, adapter)
  end

  @doc """
  Default adapter to be used for making requests.
  """
  def default_adapter do
    Application.get_env(:pinxs, :adapter, {Tesla.Adapter.Gun, [timeout: 30_000]})
  end

  @doc """
  Default URL for communicating with Pin Payments
  """
  def default_url do
    "https://api.pin.net.au/1"
  end

  def test_url do
    "https://test-api.pin.net.au/1"
  end
end
