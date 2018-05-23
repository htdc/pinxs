defmodule PINXS.Balance do
  alias PINXS.HTTP.API
  alias __MODULE__

  @moduledoc """
  Provides a function for retrieving your balance
  """
  defstruct [:available, :pending]

  @type t :: %__MODULE__{
          available: [%{amount: integer(), currency: String.t()}],
          pending: [%{amount: integer(), currency: String.t()}]
        }

  @doc """
  Retrieves your balance information
  """
  @spec get() :: {:ok, Balance.t()} | {:error, PINXS.Error.t()}
  def get() do
    API.get("/balance", __MODULE__)
  end
end
