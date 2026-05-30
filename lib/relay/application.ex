defmodule Relay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Relay.Repo,
      # The web layer: a plain Plug.Router served by Bandit.
      {Bandit, plug: Relay.Router, scheme: :http, port: port()}
    ]

    # Exq starts itself via :extra_applications (see mix.exs); it is not
    # supervised here.
    opts = [strategy: :one_for_one, name: Relay.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:relay, :port, 4000)
end
