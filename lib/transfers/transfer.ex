defmodule PINXS.Transfers.Transfer do
  alias PINXS.HTTP.API
  alias __MODULE__

  @moduledoc """
  Proived functions for creating and working with transfers
  """

  @derive [Poison.Encoder, Jason.Encoder]
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
          created_at: nil | String.t(),
          currency: nil | String.t(),
          description: nil | String.t(),
          paid_at: nil | String.t(),
          recipient: String.t(),
          reference: nil | String.t(),
          status: nil | String.t(),
          token: nil | String.t(),
          total_credits: nil | integer(),
          total_debits: nil | integer()
        }

  @doc """
  Create a transfer
  """
  def create(%Transfer{currency: "AUD"} = transfer, config) do
    API.post("/transfers", transfer, __MODULE__, config)
  end

  def create(%Transfer{} = transfer, config) do
    Map.put(transfer, :currency, "AUD")
    |> create(config)
  end

  @doc """
  Gets a transfer
  """
  def get(transfer_token, config) do
    API.get("/transfers/#{transfer_token}", __MODULE__, config)
  end

  @doc """
  Gets a paginated list of transfers
  """
  def get_all(config) do
    API.get("/transfers", __MODULE__, config)
  end

  @doc """
  Gets a specific pages of transfers
  """
  def get_all(page, config) when is_integer(page) do
    API.get("/transfers?page=#{page}", __MODULE__, config)
  end

  def get_line_items(transfer_token, config) do
    API.get("/transfers/#{transfer_token}/line_items", __MODULE__, config)
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

  def search(query_map, %Tesla.Client{} = config) do
    API.search("/transfers/search", Map.to_list(query_map), __MODULE__, config)
  end

  def search(query_map, config) do
    API.search("/transfers/search", query_map, __MODULE__, config)
  end
end
