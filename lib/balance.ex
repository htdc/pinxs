defmodule PINXS.Balance do
  alias PINXS.HTTP.API

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
  def get(config) do
    API.get("/balance", __MODULE__, config)
  end
end
