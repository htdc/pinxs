defmodule PINXS.BankAccounts.BankAccount do
  @moduledoc """
  Used for interacting with BankAccounts in Pin Payments
  """
  alias PINXS.HTTP.API
  alias __MODULE__

  @derive [Jason.Encoder]
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
  def create(%BankAccount{} = bank_account, config) do
    API.post("/bank_accounts", bank_account, __MODULE__, config)
  end
end
