use Mix.Config

config :pinxs,
  api_key: "{PIN_PAYMENTS_API_KEY}",
  pin_url: "https://test-api.pin.net.au/1"

if Mix.env() == :test do
  config :exvcr,
    vcr_cassette_library_dir: "test/http_recordings",
    filter_request_headers: ["Authorization"]
end
