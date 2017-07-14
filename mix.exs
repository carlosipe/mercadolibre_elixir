defmodule Mercadolibre.Mixfile do
  use Mix.Project

  def project do
    [app: :mercadolibre,
     version: "0.1.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "An elixir wrapper for MercadoLibre.com API",
     package: package,
     deps: deps()]
  end

  defp package do
    [
      maintainers: ["CarlosIPe"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/carlosipe/mercadolibre_elixir"}
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.12"},
      {:exjsx, "~> 4.0.0"},
      {:ex_doc, "~> 0.10", only: :dev}
    ]

  end
end
