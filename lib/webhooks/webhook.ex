defmodule PINXS.Webhooks.Webhook do
  alias PINXS.HTTP.API
  alias __MODULE__

  @moduledoc """
  The webhook module allows you to create and view your webhook endpoints.

  ## Required fields
  When creating a webhook only URL is required

  ```
  create(%Webhook{url: "https://awesome.com"}, PINXS.config("my key"))
  ```
  """

  @derive [Poison.Encoder]
  defstruct [
    :url,
    :token,
    :key,
    :created_at,
    :updated_at
  ]

  @type t :: %__MODULE__{
          url: String.t(),
          token: nil | String.t(),
          key: nil | String.t(),
          created_at: nil | DateTime.t(),
          updated_at: nil | DateTime.t()
        }

  @doc """
  Creates a webhook
  """
  def create(%Webhook{} = webhook, %PINXS{} = config) do
    API.post("/webhook_endpoints", webhook, __MODULE__, config)
  end

  def delete(token, %PINXS{} = config) do
    API.delete("/webhook_endpoints/#{token}", __MODULE__, config)
  end

  def get(%PINXS{} = config) do
    API.get("/webhook_endpoints", __MODULE__, config)
  end

  def get(token, %PINXS{} = config) do
    API.get("/webhook_endpoints/#{token}", __MODULE__, config)
  end
end
