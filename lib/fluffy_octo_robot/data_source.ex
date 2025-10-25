defmodule FluffyOctoRobot.DataSource do
  @moduledoc "This is where all the Postgres Stuff Lives"

  alias FluffyOctoRobot.Repo
  import Ecto.Query

  def fetch_data(user_id, query_type) do
    query =
      case query_type do
        :query_1 -> build_query_1(user_id)
        :query_2 -> build_query_2(user_id)
        :query_3 -> build_query_3(user_id)
        _ -> :invalid_query
      end

      if query == :invalid_query do
        {:error, :invalid_query_type}
      else
        data = Repo.all(query)

        if Enum.empty?(data),
          do: {:error, :not_found},
          else: {:ok, data}
      end
  end

  defp build_query_1(user_id) do
    from u in "users",
      where: u.id == ^user_id,
      select: %{user_id: u.id, created_at: u.created_at}
  end

  defp build_query_2(user_id) do
    from u in "users",
      where: u.id == ^user_id,
      select: %{user_id: u.id, updated_at: u.updated_at}
  end

  defp build_query_3(user_id) do
    from u in "users",
      where: u.id == ^user_id,
      select: %{user_id: u.id, last_active: u.last_active}
  end
end
