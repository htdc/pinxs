defmodule PINXS.Error do
  @moduledoc """
  Provides a struct for dealing with errors.

  ## Sample output

  ```
  %PINXS.Error{
    error: "invalid_resource",
    error_description: "One or more parameters were missing or invalid",
    messages: %{
      code: "email_invalid",
      message: "Email isn't valid",
      param: "email"
    }
  }

  """
  defstruct [
    :error,
    :error_description,
    :messages,
    :module
  ]

  @type t :: %__MODULE__{
          error: String.t(),
          error_description: String.t(),
          module: module(),
          messages: [%{param: String.t(), code: String.t(), message: String.t()}]
        }
end
