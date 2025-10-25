defmodule FluffyOctoRobot.Pipeline do
  @moduledoc "Shared code between all Insight Services"

  alias FluffyOctoRobot.DataSource
  alias FluffyOctoRobot.DataProcess

  def run_for_user(user_id, query_type) do
    with {:ok, raw_data} <- DataSource.fetch_data(user_id, query_type),
         {:ok, feature_vector} <- DataProcess.process_data(raw_data, query_type) do
      {:ok, feature_vector}
      else
        {:error, reason} -> {:error, reason}
    end
  end
end
