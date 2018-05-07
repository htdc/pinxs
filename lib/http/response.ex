defmodule PinPayments.HTTP.Response do
  def normalize({:ok, %{status: status} = response}) when status in 200..299, do: {:ok, response}
  def normalize({:ok, response}), do: {:error, response}
  def normalize(any), do: any
end
