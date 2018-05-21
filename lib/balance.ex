defmodule PinPayments.Balance do
  alias PinPayments.HTTP.API
  alias __MODULE__

  defstruct [:available, :pending]

  def get() do
    API.get("/balance")
    |> handle_response
  end

  defp handle_response({:ok, response}) do
    handle_response(response.body)
  end

  defp handle_response(%{response: response}) do
    {:ok, struct(%Balance{}, response)}
  end
  defp handle_response(response)
end
