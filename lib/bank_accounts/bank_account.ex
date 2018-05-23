defmodule PinPayments.BankAccounts.BankAccount do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
  alias __MODULE__

  @derive [Poison.Encoder]
  defstruct [
    :token,
    :name,
    :bsb,
    :number,
    :bank_name,
    :branch
  ]

  @type t :: %__MODULE__{
          token: nil | String.t(),
          name: String.t(),
          bsb: String.t(),
          number: String.t(),
          bank_name: String.t(),
          branch: String.t()
        }


  @doc """
  Create a bank account
  """
  @spec create(BankAccount.t) :: {:ok, BankAccount.t} | {:error, PinPayments.Error.t}
  def create(%BankAccount{} = bank_account) do
    API.post("/bank_accounts", bank_account)
    |> Response.transform(__MODULE__)
  end
end
