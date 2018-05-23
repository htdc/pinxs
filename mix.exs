defmodule PINXS.MixProject do
  use Mix.Project

  def project do
    [
      app: :pinxs,
      version: "0.1.0",
      elixir: "~> 1.6",
      source_url: "https://github.com/htdc/pinxs",
      description: """
      Use Pin Payments via Elixir
      """,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [
        logo: "./images/pin_payments.png",
        extras: ["README.md"],
        main: "readme"
      ]
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      maintainers: ["Martin Feckie"],
      links: %{
        "Github"=> "https://github.com/htdc/pinxs"
      }
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
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:exvcr, "~> 0.10", only: :test},
      {:mix_test_watch, "~> 0.6", only: :dev},
      {:hackney, "~> 1.12"},
      {:httpoison, "~> 1.1.1"},
      {:poison, "~> 3.1"}
    ]
  end
end
