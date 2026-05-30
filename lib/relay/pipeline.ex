defmodule Relay.Pipeline do
  @moduledoc """
  Reusable orchestration shared across services: a pure `with` chain over the
  data layers. No service-specific logic lives here.
  """

  alias Relay.DataProcess
  alias Relay.DataSource

  @spec run_for_user(integer(), atom()) :: {:ok, [map()]} | {:error, term()}
  def run_for_user(user_id, query_type) do
    with {:ok, raw_data} <- DataSource.fetch_data(user_id, query_type) do
      DataProcess.process_data(raw_data, query_type)
    end
  end
end
