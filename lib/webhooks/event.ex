defmodule PINXS.Webhooks.Event do
  alias PINXS.HTTP.API

  @moduledoc """
  The Webhook Event module allows you to view webhook events.
  """

  @derive [Jason.Encoder]
  defstruct [
    :token,
    :type,
    :data,
    :created_at
  ]

  @type t :: %__MODULE__{
          token: String.t(),
          type: String.t(),
          data: map(),
          created_at: String.t()
        }

  @doc """
  Get webhook events
  """
  def get_all(%Tesla.Client{} = config) do
    API.get("/events?per_page=500", __MODULE__, config)
  end

  @doc """
  Get webhook events by page
  """
  def get_all(page, %Tesla.Client{} = config) do
    API.get("/events?per_page=500&page=#{page}", __MODULE__, config)
  end

  @doc """
  Get a webhook event
  """
  def get(token, %Tesla.Client{} = config) do
    API.get("/events/#{token}", __MODULE__, config)
  end
end
