defmodule FluffyOctoRobot.DataProcess do

  import Explorer.DataFrame

  def process_data(raw_data, query_type) do
    case query_type do
      :query_1 -> process_query_1(raw_data)
      :query_2 -> process_query_2(raw_data)
      :query_3 -> process_query_3(raw_data)
      _ -> {:error, :invalid_query_type}
    end
  end

  defp process_query_1(raw_data) do
    try do
      df =
        raw_data
        |> new()
        |> mutate(user_id: user_id + 1)
      feature_vector =
        df
        |> to_rows()

      {:ok, feature_vector}

    rescue
      e in [RuntimeError] -> {:error, e.message}
    end
  end

  defp process_query_2(raw_data) do
    try do
      df =
        raw_data
        |> new()
        |> mutate(user_id: user_id + 1)
      feature_vector =
        df
        |> to_rows()

      {:ok, feature_vector}

    rescue
      e in [RuntimeError] -> {:error, e.message}
    end
  end

  defp process_query_3(raw_data) do
    try do
      df =
        raw_data
        |> new()
        |> mutate(user_id: user_id + 1)
      feature_vector =
        df
        |> to_rows()

      {:ok, feature_vector}

    rescue
      e in [RuntimeError] -> {:error, e.message}
    end
  end
end
