defmodule Relay.DataCase do
  @moduledoc """
  Test case for tests that touch the database.

  Enables the Ecto SQL sandbox so each test runs in its own transaction and is
  rolled back at the end. Use `async: true` for tests that don't share state.
  Also provides small fixtures used across the suite.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias Relay.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Relay.DataCase
    end
  end

  setup tags do
    Relay.DataCase.setup_sandbox(tags)
    :ok
  end

  @doc """
  Sets up the sandbox based on the test tags.
  """
  def setup_sandbox(tags) do
    pid = Sandbox.start_owner!(Relay.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
  end

  @doc """
  Inserts a `Relay.User` with all timestamp fields populated and returns it.
  """
  def insert_user(attrs \\ %{}) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    %Relay.User{
      created_at: Map.get(attrs, :created_at, now),
      updated_at: Map.get(attrs, :updated_at, now),
      last_active: Map.get(attrs, :last_active, now)
    }
    |> Relay.Repo.insert!()
  end
end
