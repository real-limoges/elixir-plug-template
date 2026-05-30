# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :relay,
  ecto_repos: [Relay.Repo],
  generators: [timestamp_type: :utc_datetime]

# HTTP listener port for Bandit (see Relay.Application).
config :relay, port: 4000

# Background jobs (Exq). One queue per job type; add a queue when you add an
# insight. `name: Exq` must match the `Exq.enqueue(Exq, ...)` call sites.
config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  queues: ["insight_a", "insight_b"]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
