defmodule PINXS.Refunds.Refund do
  alias PINXS.HTTP.API
  alias PINXS.Response
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
    amount: Integer.t,
    currency: String.t,
    charge: String.t,
    created_at: String.t,
    error_message: String.t,
    status_message: String.t
  }

  @doc """
  Create a refund from a given charge
  """
  @spec create(Charge.t, map()) :: {:ok, Refund.t} | {:error, PINXS.Error.t}
  def create(%Charge{token: token}, amount \\ %{}) do
    API.post("/charges/#{token}/refunds", amount)
    |> Response.transform(__MODULE__)
  end

  @doc """
  Retrieves a specific refunds
  """
  @spec get(Refund.t) :: {:ok, Refund.t} | {:error, PINXS.Error.t}
  def get(%Refund{token: token}) do
    API.get("/refunds/#{token}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Get a paginated list of refunds
  """
  @spec get_all() :: {:ok, [Refund.t]} | {:error, PINXS.Error.t}
  def get_all() do
    API.get("/refunds")
    |> Response.transform(__MODULE__)
  end
  @doc """
  Gets a specific page of refunds
  """
  @spec get_all(Integer.t) :: {:ok, [Refund.t]} | {:error, PINXS.Error.t}
  def get_all(page) when is_integer(page) do
    API.get("/refunds?page=#{page}")
    |> Response.transform(__MODULE__)
  end

  @doc """
  Gets refunds for a specific charge
  """
  @spec get_all_for_charge(Charge.t) :: {:ok, [Refund.t]} | {:error, PINXS.Error.t}
  def get_all_for_charge(%Charge{token: token}) do
    API.get("/charges/#{token}/refunds")
    |> Response.transform(__MODULE__)
  end


end
