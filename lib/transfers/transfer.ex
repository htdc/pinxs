defmodule PINXS.Transfers.Transfer do
  alias PINXS.HTTP.API
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
    reference: nil | String.t,
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
    API.post("/transfers", transfer, __MODULE__)
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
    API.get("/transfers/#{transfer_token}", __MODULE__)
  end

  @doc """
  Gets a paginated list of transfers
  """
  @spec get_all() :: {:ok, [Transfer.t]} | {:error, PINXS.Error.t}
  def get_all() do
    API.get("/transfers", __MODULE__)
  end

  @doc """
  Gets a specific pages of transfers
  """
  @spec get_all(non_neg_integer()) :: {:ok, [Transfer.t]} | {:error, PINXS.Error.t}
  def get_all(page) when is_integer(page) do
    API.get("/transfers?page=#{page}", __MODULE__)
  end

  def get_line_items(transfer_token) do
    API.get("/transfers/#{transfer_token}/line_items",__MODULE__)
  end

    @doc """
  Retrieve transfers based on search criteria

  ## Search options
  ```
  %{
    query: "",
    start_date: "YYYY/MM/DD", # 2013/01/01
    end_date: "YYYY/MM/DD", # 2013/12/25
    sort: "", # field to sort by, default `created_at`
    direction: 1 # 1 or -1
  }
  ```
  """

  @spec search(map()) :: {:ok, [Transfer.t]} | {:error, PINXS.Error.t()}
  def search(query_map) do
    API.search("/transfers/search", query_map, __MODULE__)
  end
end
