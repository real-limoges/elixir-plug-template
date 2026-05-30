defmodule Relay.MixProject do
  use Mix.Project

  def project do
    [
      app: :relay,
      version: "0.1.0",
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        flags: [:error_handling, :extra_return, :missing_return, :unknown],
        # precommit runs in MIX_ENV=test, which compiles test/support; add the
        # test toolchain to the PLT so those modules' callbacks are known.
        plt_add_apps: [:ex_unit, :mix]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Relay.Application, []},
      extra_applications: [:logger, :runtime_tools, :exq]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Web layer
      {:plug, "~> 1.16"},
      {:bandit, "~> 1.5"},
      {:jason, "~> 1.2"},
      # Database
      {:ecto_sql, "~> 3.13"},
      {:postgrex, ">= 0.0.0"},
      # Background jobs
      {:exq, "~> 0.22.0"},
      # HTTP client
      {:req, "~> 0.5"},
      # Data / numerics
      {:nx, "~> 0.7"},
      {:explorer, "~> 0.8"},
      # Tooling
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      precommit: [
        "compile --warning-as-errors",
        "deps.unlock --unused",
        "format --check-formatted",
        "credo --strict",
        "dialyzer",
        "test"
      ]
    ]
  end
end
