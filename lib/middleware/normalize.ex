defmodule PINXS.Middleware.Normalize do
  @behaviour Tesla.Middleware
  alias Tesla.Env

  def call(%Env{} = env, next, _options) do
    with {:ok, response} <- Tesla.run(env, next),
         {:ok, transformed} <- transform(response) do
      {:ok, transformed}
    end
  end

  defp transform(%Env{status: status} = env) when status in 200..299 do
    {:ok, env}
  end

  defp transform(%Env{status: status} = env) when status in 400..599 do
    {:error, env}
  end
end
