defmodule PINXS.Transfers.Transfer do
  alias PINXS.HTTP.API
  alias PINXS.Response
  alias __MODULE__

  @moduledoc """
  Proived functions for creating and working with transfers
  """

  @derive [Poison.Encoder]
  defstruct [
    :amount,
    :bank_account,
    :created_at,
    :currency,
    :description,
    :paid_at,
    :recipient,
    :reference,
    :status,
    :token,
    :total_credits,
    :total_debits
  ]
  @type t :: %__MODULE__{
    amount: integer(),
    bank_account: nil | PINXS.BankAccounts.BankAccount,
    created_at: nil | String.t,
    currency: nil | String.t,
    description: nil | String.t,
    paid_at: nil | String.t,
    recipient: String.t,
    reference: String.t,
    status: nil | String.t,
    token: nil | String.t,
    total_credits: nil | integer(),
    total_debits: nil | integer()
  }

  @doc """
  Create a transfer
  """
  @spec create(Transfer.t) :: {:ok, Transfer.t} | {:error, PINXS.Error.t}
  def create(%Transfer{currency: "AUD"} = transfer) do
    API.post("/transfers", transfer)
    |> Response.transform(__MODULE__)
  end

  def create(%Transfer{} = transfer) do
    Map.put(transfer, :currency, "AUD")
    |> create
  end

  @doc """
  Gets a transfer
  """
  @spec get(String.t) :: {:ok, Transfer.t} | {:error, PINXS.Error.t}
  def get(transfer_token) do
    API.get("/transfers/#{transfer_token}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Gets a paginated list of transfers
  """
  @spec get_all() :: {:ok, [Transfer.t]} | {:error, PINXS.Error.t}
  def get_all() do
    API.get("/transfers")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Gets a specific pages of transfers
  """
  @spec get_all(non_neg_integer()) :: {:ok, [Transfer.t]} | {:error, PINXS.Error.t}
  def get_all(page) when is_integer(page) do
    API.get("/transfers?page=#{page}")
    |> Response.transform(__MODULE__)
  end

  def get_line_items(transfer_token) do
    API.get("/transfers/#{transfer_token}/line_items")
    |> Response.transform(__MODULE__)
  end
end
