defmodule Relay.DataProcess do
  @moduledoc """
  Pure data transformation: raw rows → feature vector, via Explorer dataframes
  (+ Nx). No side effects.

  `query_type` is threaded through so transforms can diverge per query in the
  future; today a single implementation serves all of them — branch here when
  they actually need to differ.
  """

  import Explorer.DataFrame

  @spec process_data([map()], atom()) :: {:ok, [map()]} | {:error, term()}
  def process_data(raw_data, _query_type) do
    # STUB transform: build a dataframe and derive a feature vector. Replace the
    # body with the real feature engineering for your model.
    feature_vector =
      raw_data
      |> new()
      |> mutate(user_id: user_id + 1)
      |> to_rows()

    {:ok, feature_vector}
  rescue
    e in [RuntimeError, ArgumentError] -> {:error, Exception.message(e)}
  end
end
