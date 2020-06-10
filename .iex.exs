alias PINXS.HTTP.PinApi
alias PINXS.Cards.Card
alias PINXS.Charges.Charge

keys = PINXS.config(System.get_env("PIN_API_KEY"))
test_keys = PINXS.config(System.get_env("PIN_TEST_API_KEY"))
client = PINXS.Client.new(keys)
test_client = PINXS.Client.new(keys, PINXS.Client.test_url())
