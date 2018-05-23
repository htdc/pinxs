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
  defstruct [
    :token,
    :name,
    :email,
    :created_at,
    :bank_account,
    :bank_account_token
  ]

  @type t :: %__MODULE__{
          token: String.t(),
          name: nil | String.t(),
          email: String.t(),
          created_at: nil | String.t(),
          bank_account: nil | map(),
          bank_account_token: nil | String.t()
        }

  @doc """
  Create a recipient
  """
  @spec create(Recipient.t()) :: {:ok, Recipient.t()} | {:error, PINXS.Error.t()}
  def create(%Recipient{bank_account: bank_account} = recipient) when not is_nil(bank_account) do
    API.post("/recipients", recipient, __MODULE__)
  end

  def create(%Recipient{bank_account_token: bank_account_token} = recipient) when not is_nil(bank_account_token) do
    API.post("/recipients", recipient, __MODULE__)
  end


  @doc """
  Gets a recipient
  """
  @spec get(String.t) :: {:ok, Recipient.t} | {:error, PINXS.Error.t}
  def get(recipient_token) do
    API.get("/recipients/#{recipient_token}", __MODULE__)
  end

  @doc """
  Gets a paginated list of recipients
  """
  @spec get_all() :: {:ok, [Recipient.t]} | {:error, PINXS.Error.t}
  def get_all() do
    API.get("/recipients", __MODULE__)
  end

  @doc """
  Get a specific page of recipients
  """
  def get_all(page) do
    API.get("/recipients?page=#{page}", __MODULE__)
  end

  @doc """
  Update recipient details
  """
  def update_recipient(%Recipient{ token: token}, params) do
    API.put("/recipients/#{token}", params, __MODULE__)
  end
end
