use Mix.Config

if Mix.env() == :test do
  config :exvcr,
    vcr_cassette_library_dir: "test/http_recordings",
    filter_request_headers: ["Authorization"]
end
