defmodule Relay.DataSource do
  @moduledoc """
  The repository layer: all database access lives here.

  Reads are schema-based (`Relay.User`) and return `{:ok, rows} | {:error, reason}`.
  `query_type` selects which projection to read — the branches diverge by design,
  so adding a new read means adding a `query/2` clause here.
  """

  import Ecto.Query

  alias Relay.Repo
  alias Relay.User

  @spec fetch_data(integer(), atom()) ::
          {:ok, [map()]} | {:error, :not_found | :invalid_query_type}
  def fetch_data(user_id, query_type) do
    with {:ok, query} <- query(user_id, query_type) do
      case Repo.all(query) do
        [] -> {:error, :not_found}
        rows -> {:ok, rows}
      end
    end
  end

  defp query(user_id, :query_1) do
    {:ok,
     from(u in User, where: u.id == ^user_id, select: %{user_id: u.id, created_at: u.created_at})}
  end

  defp query(user_id, :query_2) do
    {:ok,
     from(u in User, where: u.id == ^user_id, select: %{user_id: u.id, updated_at: u.updated_at})}
  end

  defp query(user_id, :query_3) do
    {:ok,
     from(u in User,
       where: u.id == ^user_id,
       select: %{user_id: u.id, last_active: u.last_active}
     )}
  end

  defp query(_user_id, _query_type), do: {:error, :invalid_query_type}
end
