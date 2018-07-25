use Mix.Config

if Mix.env() == :test do
  config :pinxs,
    pin_url: "https://test-api.pin.net.au/1"

  config :exvcr,
    vcr_cassette_library_dir: "test/http_recordings",
    filter_request_headers: ["Authorization"]
end
