

defmodule PinPayments.Response do
  def transform({:ok, %{body: %{ response: response}}}, module) do
    {:ok, struct(module, response)}
  end

  def transform({:error, %{body: body}}, module) do
    error = struct(%PinPayments.Error{}, body)
    |> Map.put(:module, module)
    {:error, error}
  end
end
