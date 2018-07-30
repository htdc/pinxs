defmodule PINXS.Refunds.Refund do
  alias PINXS.HTTP.API
  alias PINXS.Charges.Charge
  alias __MODULE__

  @moduledoc """
  Provides functions for working with refunds
  """

  @derive [Poison.Encoder]
  defstruct [
    :token,
    :success,
    :amount,
    :currency,
    :charge,
    :created_at,
    :error_message,
    :status_message
  ]

  @type t :: %__MODULE__{
    token: String.t,
    success: boolean(),
    amount: integer(),
    currency: String.t,
    charge: String.t,
    created_at: String.t,
    error_message: String.t,
    status_message: String.t
  }

  @doc """
  Create a refund from a given charge
  """
  @spec create(Charge.t, map(), PINXS.t()) :: {:ok, Refund.t} | {:error, PINXS.Error.t}
  def create(%Charge{token: token}, amount \\ %{}, %PINXS{} = config) do
    API.post("/charges/#{token}/refunds", amount, __MODULE__, config)
  end

  @doc """
  Retrieves a specific refunds
  """
  @spec get(Refund.t(), PINXS.t()) :: {:ok, Refund.t} | {:error, PINXS.Error.t}
  def get(%Refund{token: token}, %PINXS{} = config) do
    API.get("/refunds/#{token}", __MODULE__, config)
  end

  @doc """
  Get a paginated list of refunds
  """
  @spec get_all(PINXS.t()) :: {:ok, [Refund.t]} | {:error, PINXS.Error.t}
  def get_all(%PINXS{} = config) do
    API.get("/refunds", __MODULE__, config)
  end
  @doc """
  Gets a specific page of refunds
  """
  @spec get_all(integer(), PINXS.t()) :: {:ok, [Refund.t]} | {:error, PINXS.Error.t}
  def get_all(page, %PINXS{} = config) when is_integer(page) do
    API.get("/refunds?page=#{page}", __MODULE__, config)
  end

  @doc """
  Gets refunds for a specific charge
  """
  @spec get_all_for_charge(Charge.t, PINXS.t()) :: {:ok, [Refund.t]} | {:error, PINXS.Error.t}
  def get_all_for_charge(%Charge{token: token}, %PINXS{} = config) do
    API.get("/charges/#{token}/refunds", __MODULE__, config)
  end
end
