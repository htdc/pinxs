defmodule PINXS.Middleware.KeepRequest do
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
