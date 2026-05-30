import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used to provide built-in
# test partitioning in CI. Run `mix help test` for more information.
config :relay, Relay.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "relay_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# Run Exq without Redis in tests: don't start the Exq supervision tree, and
# route enqueues through Exq.Mock (started in test/test_helper.exs).
config :exq,
  start_on_application: false,
  queue_adapter: Exq.Adapters.Queue.Mock

# Print only warnings and errors during test
config :logger, level: :warning
