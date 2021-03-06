defmodule PINXS.Refunds.Refund do
  alias PINXS.HTTP.API
  alias PINXS.Charges.Charge
  alias __MODULE__

  @moduledoc """
  Provides functions for working with refunds
  """

  @derive [Jason.Encoder]
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
          token: String.t(),
          success: boolean(),
          amount: integer(),
          currency: String.t(),
          charge: String.t(),
          created_at: String.t(),
          error_message: String.t(),
          status_message: String.t()
        }

  @doc """
  Create a refund from a given charge
  """
  def create(%Charge{token: token}, amount \\ %{}, config) do
    API.post("/charges/#{token}/refunds", amount, __MODULE__, config)
  end

  @doc """
  Retrieves a specific refunds
  """
  def get(%Refund{token: token}, config) do
    API.get("/refunds/#{token}", __MODULE__, config)
  end

  @doc """
  Get a paginated list of refunds
  """
  def get_all(config) do
    API.get("/refunds", __MODULE__, config)
  end

  @doc """
  Gets a specific page of refunds
  """
  def get_all(page, config) when is_integer(page) do
    API.get("/refunds?page=#{page}", __MODULE__, config)
  end

  @doc """
  Gets refunds for a specific charge
  """
  def get_all_for_charge(%Charge{token: token}, config) do
    API.get("/charges/#{token}/refunds", __MODULE__, config)
  end
end
