defmodule PINXS.HTTP.Response do
  @moduledoc """
  Provides a standard way of converting all HTTP responses into tagged
  tuples

  In particular, all failed requests will be transformed into error tuples.

  The reason for this is that whilst the network request may have been successful,
  we consider any HTTP status code not in the  200 range to be an error.
  """

  @spec transform({:ok, map()} | {:error, map()}, module()) ::
          {:ok, struct()} | {:error, PINXS.Error.t()}
  def transform(
        {:ok, %{body: %{count: count, pagination: pagination, response: response}}},
        module
      )
      when is_list(response) and not is_nil(count) and not is_nil(pagination) do
    paginated =
      %{}
      |> Map.put(:count, count)
      |> Map.put(:pagination, pagination)
      |> Map.put(:items, Enum.map(response, &struct(module, &1)))

    {:ok, paginated}
  end

  def transform({:ok, %{status_code: 204}}, _module), do: {:ok, true}

  def transform({:ok, %{body: %{response: response}}}, module) when is_list(response) do
    {:ok, Enum.map(response, &struct(module, &1))}
  end

  def transform({:ok, %{body: %{response: response}}}, module) do
    {:ok, struct(module, response)}
  end

  def transform({:error, %{body: body}}, module) do
    error =
      struct(%PINXS.Error{}, body)
      |> Map.put(:module, module)

    {:error, error}
  end
end
