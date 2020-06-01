defmodule PINXS.MixProject do
  use Mix.Project

  def project do
    [
      app: :pinxs,
      version: "2.0.3",
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
      {:gun, "> 1.3.0"},
      {:mix_test_watch, "~> 0.6", only: :dev},
      {:nug, "> 0.3.0", only: [:dev, :test]},
      {:httpoison, "~> 1.2.0"},
      {:poison, "~> 3.1"},
      {:tesla, "~> 1.3"}
    ]
  end
end
