defmodule Relay.User do
  @moduledoc """
  Ecto schema backing the `users` table that `Relay.DataSource` reads from.

  The timestamp fields are declared explicitly (not via `timestamps()`) because
  the data layer selects `created_at` / `updated_at` / `last_active` by those
  exact column names.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "users" do
    field :created_at, :utc_datetime
    field :updated_at, :utc_datetime
    field :last_active, :utc_datetime
  end

  @spec changeset(t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:created_at, :updated_at, :last_active])
    |> validate_required([:created_at, :updated_at, :last_active])
  end
end
