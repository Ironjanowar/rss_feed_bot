defmodule RssFeedBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :rss_feed_bot,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RssFeedBot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.5.0-rc3"},
      {:redix, ">= 0.8.2"},
      {:httpoison, "~> 1.4"},
      {:floki, "~> 0.20.0"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.0"},
      {:nimble_parsec, "0.4.0"}
    ]
  end
end
