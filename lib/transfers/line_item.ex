defmodule PINXS.Transfers.LineItem do
  @derive [Jason.Encoder]
  defstruct [
    :type,
    :amount,
    :currency,
    :created_at,
    :object,
    :token,
    :record
  ]

  @type t :: %__MODULE__{
          type: nil | String.t(),
          amount: integer(),
          currency: nil | String.t(),
          created_at: nil | String.t(),
          object: nil | String.t(),
          token: nil | String.t(),
          record: map()
        }
end
