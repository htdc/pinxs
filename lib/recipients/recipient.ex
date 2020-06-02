defmodule PINXS.Recipients.Recipient do
  alias PINXS.HTTP.API
  alias __MODULE__

  @moduledoc """
  Provides functions for working with payment recipients

  ## Required fields

  All recipients require the following fields

  - email

  And one of the following

  - bank_account
  - bank_account_token
  """
  @derive Jason.Encoder
  defstruct [
    :token,
    :name,
    :email,
    :created_at,
    :bank_account,
    :bank_account_token
  ]

  @type t :: %__MODULE__{
          token: nil | String.t(),
          name: nil | String.t(),
          email: String.t(),
          created_at: nil | String.t(),
          bank_account: nil | map(),
          bank_account_token: nil | String.t()
        }

  @doc """
  Create a recipient
  """
  def create(%Recipient{bank_account: bank_account} = recipient, config)
      when not is_nil(bank_account) do
    API.post("/recipients", recipient, __MODULE__, config)
  end

  def create(%Recipient{bank_account_token: bank_account_token} = recipient, config)
      when not is_nil(bank_account_token) do
    API.post("/recipients", recipient, __MODULE__, config)
  end

  @doc """
  Gets a recipient
  """
  def get(recipient_token, config) do
    API.get("/recipients/#{recipient_token}", __MODULE__, config)
  end

  @doc """
  Gets a paginated list of recipients
  """
  def get_all(config) do
    API.get("/recipients", __MODULE__, config)
  end

  @doc """
  Get a specific page of recipients
  """
  def get_all(page, config) do
    API.get("/recipients?page=#{page}", __MODULE__, config)
  end

  @doc """
  Update recipient details
  """
  def update_recipient(%Recipient{token: token}, params, config) do
    API.put("/recipients/#{token}", params, __MODULE__, config)
  end
end
