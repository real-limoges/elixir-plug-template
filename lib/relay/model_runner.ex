defmodule Relay.ModelRunner do
  @moduledoc """
  Runs a model against a feature vector and returns a prediction.

  This is a **stub**: real inference (Nx, Bumblebee, or an external service)
  would live here. It returns a deterministic placeholder so the example flow
  runs end-to-end.
  """

  require Logger

  @spec run(String.t(), [map()]) :: {:ok, map()} | {:error, term()}
  def run(_model_name, []), do: {:error, :empty_feature_vector}

  def run(model_name, data) when is_list(data) do
    rows = length(data)
    Logger.info("[ModelRunner] running #{model_name} on #{rows} row(s)")

    # STUB: swap this for real inference. Returns a canned prediction.
    {:ok, %{model: model_name, prediction: :stub, rows: rows}}
  end
end
