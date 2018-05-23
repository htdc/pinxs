defmodule PINXS.MixProject do
  use Mix.Project

  def project do
    [
      app: :pinxs,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        logo: "./images/pin_payments.png",
        extras: ["README.md"]
      ]
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
      {:exvcr, "~> 0.10", only: :test},
      {:mix_test_watch, "~> 0.6", only: :dev},
      {:hackney, "~> 1.12"},
      {:httpoison, "~> 1.1.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
