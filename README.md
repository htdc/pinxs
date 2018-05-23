![Pin Payments](https://pinpayments.com/assets/logo/default-2145a56bb434325675be86250bbbd1dc86f77b5f12fbedeee0bf31d5b7ce8438.svg)
# PINXS

What could be a more Australian name for an Elixir library when using [Pin Payments](https://pinpayments.com/)?

Made with love at [HotDoc](https://www.hotdoc.com.au)

![HotDoc](https://d4c51m54o196o.cloudfront.net/assets/website/logos/hotdoc-logo-b3cd790d36793669cc9d528780f46af7.svg)

## Installation

```elixir
def deps do
  [
    {:pinxs, "~> 0.1.0"}
  ]
end
```

You will also need to add your API key to your config.

```elixir
config :pinxs,
  api_key: "${PIN_PAYMENTS_API_KEY}",
  pin_url: "https://api.pinpayments.com" # or "https://test-api.pin.net.au/1" in test environment
```

## Overview

All responses are transformed to return `{:ok, item(s)}` or `{:error, PINX.Error}`

This enables us to leverage pattern matching and the `with` construct very nicely.

### Example charge creation

```elixir
    order = Order.create(#...)

    card = %Card{
      number: "5520000000000000",
      expiry_month: "12",
      expiry_year: "20",
      name: "Rubius Hagrid",
      address_line1: "The Game Keepers Cottage",
      address_city: "Hogwarts",
      address_country: "England",
      cvc: "321"
    }

    charge = %Charge{
      email: "hagrid@hogwarts.wiz",
      description: "Dragon eggs",
      ip_address: "127.0.0.1",
      amount: 50000,
      card: card
    }

    with {:ok, created_order} <- Repo.insert(order),
         {:ok, created_charge} <- Charge.create(charge),
         {:ok, paid_order} <- Order.mark_paid(created_order, created_charge),
         {:ok, _email} <- Mailer.send("receipt", created_charge),
         {:ok, _email} <- Mailer.send("notify_fulfullment_team", order)
    do {:ok, created_order}
    else
      {:error, %Changeset{} = changeset} ->
        #response appropriately to changeset error
      {:error, %PinError{error_code: "insufficient_funds"}} ->
        Mailer.send("order_failed", charge)
      {:error, other} ->
        # handle some other error
      error -> 
        Logger.error("Some unknown error: #{IO.inspect(error)}")
    end

```