defmodule PinPayments.Error do
  defstruct [
    :error,
    :error_description,
    :messages,
    :module
  ]
end
