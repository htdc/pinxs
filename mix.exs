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
      elixirc_paths: elixirc_paths(Mix.env()),
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
        "Github" => "https://github.com/htdc/pinxs"
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :gun]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false},
      {:exvcr, "~> 0.10", only: :test},
      {:gun, "> 1.3.0"},
      {:jason, "> 1.2.0"},
      {:nug, ">= 0.3.3", only: [:dev, :test]},
      {:httpoison, "~> 1.2.0"},
      {:poison, "~> 3.1"},
      {:tesla, "> 1.3.0"}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/support/test_helpers"]
  defp elixirc_paths(_), do: ["lib"]
end
