defmodule Kittowidgets.Mixfile do
  use Mix.Project

  def project do
    [app: :kittowidgets,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [applications: [:logger, :kitto]]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:kitto, "~> 0.3.0"},
     {:httpoison, "~> 0.10.0"},
     {:poison, "~> 3.0"},
     {:html_entities, "~> 0.3"}]
  end
end
