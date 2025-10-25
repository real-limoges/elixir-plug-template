defmodule FluffyOctoRobot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FluffyOctoRobotWeb.Telemetry,
      FluffyOctoRobot.Repo,
      {DNSCluster, query: Application.get_env(:fluffy_octo_robot, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FluffyOctoRobot.PubSub},
      # Start a worker by calling: FluffyOctoRobot.Worker.start_link(arg)
      # {FluffyOctoRobot.Worker, arg},
      # Start to serve requests, typically the last entry
      FluffyOctoRobotWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FluffyOctoRobot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FluffyOctoRobotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
