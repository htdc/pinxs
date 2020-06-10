defimpl Inspect, for: Tesla.Client do
  @moduledoc """
  Used to prevent the basic authorization headers from leaking into the logs
  """
  def inspect(incoming, opts) do
    Map.put(incoming, :pre, "[FILTERED]")
    |> Inspect.Any.inspect(opts)
  end
end
