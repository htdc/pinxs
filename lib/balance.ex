defmodule PinPayments.Balance do
  alias PinPayments.HTTP.API
  alias PinPayments.Response
  alias __MODULE__

  @moduledoc """
  Provides a function for retrieving your balance
  """
  defstruct [:available, :pending]

  @type t :: %__MODULE__{
          available: [%{amount: Integer.t(), currency: String.t()}],
          pending: [%{amount: Integer.t(), currency: String.t()}]
        }

  @doc """
  Retrieves your balance information
  """
  @spec get() :: {:ok, Balance.t()} | {:error, PinPayments.Error.t()}
  def get() do
    API.get("/balance")
    |> Response.transform(__MODULE__)
  end
end
