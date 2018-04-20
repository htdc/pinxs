defmodule PinPayments.Charges.Charge do
  @derive Jason.Encoder
  defstruct [
    :email,
    :description,
    :amount,
    :ip_address,
    :currency,
    :capture,
    :metadata,
    :card,
    :card_token,
    :customer_token
  ]

  @moduledoc """
  # Required Fields

  - email
  - description
  - amount
  - ip_address

  and one of 
  - card
  - card_token
  - customer_token

  # Optional Fields

  - currency
  - capture
  - metadata

  ```
  %Card{
  "number": "5520000000000000",
  "expiry_month": "05",
  "expiry_year": "2019",
  "cvc": "123",
  "name": "Roland Robot",
  "address_line1": "42 Sevenoaks St",
  "address_city": "Lathlain",
  "address_postcode": "6454",
  "address_state": "WA",
  "address_country": "Australia"
  }
  ```
  """
end
