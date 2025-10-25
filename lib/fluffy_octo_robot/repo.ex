defmodule FluffyOctoRobot.Repo do
  use Ecto.Repo,
    otp_app: :fluffy_octo_robot,
    adapter: Ecto.Adapters.Postgres
end
