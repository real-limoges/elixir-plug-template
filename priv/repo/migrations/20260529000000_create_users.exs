defmodule Relay.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    # Columns are named to match what Relay.DataSource selects. We declare them
    # explicitly rather than using timestamps() (which would create
    # inserted_at/updated_at).
    create table(:users) do
      add :created_at, :utc_datetime
      add :updated_at, :utc_datetime
      add :last_active, :utc_datetime
    end
  end
end
