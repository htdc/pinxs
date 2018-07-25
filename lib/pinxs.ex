defmodule PINXS do
  @moduledoc false
  @enforce_keys [:api_key]
  defstruct [:api_key]

  @type t :: %__MODULE__{
    api_key: String.t()
  }

  def config(api_key) do
    %PINXS{api_key: api_key}
  end
end
