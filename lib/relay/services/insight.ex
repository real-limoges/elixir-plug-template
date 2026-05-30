defmodule Relay.Services.Insight do
  @moduledoc """
  Shared implementation behind the per-capability insight services.

  Each public service (`Relay.Services.InsightA`, `InsightB`) is a thin wrapper
  that supplies its own `job_type`/`model_name`; the orchestration and enqueue
  logic live here once. To add a third insight, copy a wrapper.
  """

  alias Relay.Pipeline
  alias Relay.Worker.TaskWorker

  # Allowlist string→atom mapping for the public `query_type` param. Never call
  # String.to_atom/1 on user input (it can exhaust the atom table).
  @query_types %{"query_1" => :query_1, "query_2" => :query_2, "query_3" => :query_3}

  @spec enqueue(String.t(), String.t(), map()) ::
          {:ok, map()} | {:error, :invalid_params | :invalid_query_type | term()}
  def enqueue(job_type, model_name, %{"user_id" => user_id, "query_type" => query_type}) do
    with {:ok, query_type} <- parse_query_type(query_type),
         {:ok, feature_vector} <- Pipeline.run_for_user(user_id, query_type),
         payload = build_payload(job_type, model_name, user_id, feature_vector),
         {:ok, _jid} <- Exq.enqueue(Exq, job_type, TaskWorker, [payload]) do
      {:ok, %{job_type: job_type, user_id: user_id}}
    end
  end

  def enqueue(_job_type, _model_name, _params), do: {:error, :invalid_params}

  # Payloads use string keys so the worker matches them identically whether or
  # not they round-trip through Redis/JSON.
  defp build_payload(job_type, model_name, user_id, feature_vector) do
    %{
      "job_type" => job_type,
      "model_name" => model_name,
      "user_id" => user_id,
      "data" => feature_vector
    }
  end

  defp parse_query_type(query_type) when is_map_key(@query_types, query_type),
    do: {:ok, @query_types[query_type]}

  defp parse_query_type(_query_type), do: {:error, :invalid_query_type}
end
