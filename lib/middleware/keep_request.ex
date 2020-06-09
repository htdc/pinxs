defmodule PINXS.Middleware.KeepRequest do
  @moduledoc """
  By default Tesla does not keep the request headers or body.

  This `Middleware` strips senstive information from the headers and then
  stores the remaining headers and body in the `opts` key.

  Mainly useful for debugging
  """
  @behaviour Tesla.Middleware
  alias Tesla.Env

  def call(%Env{} = env, next, _options) do
    filtered_headers = Enum.reject(env.headers, fn {key, _v} -> key == "authorization" end)

    env
    |> Tesla.put_opt(:request_headers, filtered_headers)
    |> Tesla.put_opt(:request_body, env.body)
    |> Tesla.run(next)
  end
end
