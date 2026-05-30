import Config

# config/runtime.exs is executed for all environments, including during
# releases. It is executed after compilation and before the system starts, so
# it is typically used to load production configuration and secrets from
# environment variables. Do not define compile-time configuration here.

# The HTTP listener port is read from PORT in every environment so releases and
# containers can override it without recompiling.
config :relay, port: String.to_integer(System.get_env("PORT") || "4000")

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :relay, Relay.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # Background jobs: point Exq at the production Redis.
  config :exq,
    host: System.get_env("REDIS_HOST") || "127.0.0.1",
    port: String.to_integer(System.get_env("REDIS_PORT") || "6379")
end
