defmodule PinPayments.MixProject do
  use Mix.Project

  def project do
    [
      app: :pin_payments,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:mix_test_watch, "~> 0.6", only: :dev},
      {:hackney, "~> 1.12"},
      {:jason, "~> 1.0"},
      {:tesla, "~> 0.10.0"}
    ]
  end
end
