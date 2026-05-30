defmodule Relay.Worker.TaskWorker do
  @moduledoc """
  Exq worker. `perform/1` matches on the job payload's `job_type` (payloads are
  maps with **string keys**), with one clause for the known types plus a
  catch-all. It delegates the real work to `Relay.ModelRunner`.
  """

  require Logger

  alias Relay.ModelRunner

  @spec perform(map()) :: :ok | :error
  def perform(%{
        "job_type" => job_type,
        "data" => data,
        "model_name" => model,
        "user_id" => user_id
      })
      when job_type in ["insight_a", "insight_b"] do
    Logger.info("[Worker] starting #{job_type} for user #{user_id}")

    case ModelRunner.run(model, data) do
      {:ok, prediction} ->
        Logger.info("[Worker] #{job_type} succeeded: #{inspect(prediction)}")
        :ok

      {:error, reason} ->
        Logger.error("[Worker] #{job_type} failed: #{inspect(reason)}")
        :error
    end
  end

  def perform(payload) do
    Logger.warning("[Worker] received an unknown payload: #{inspect(payload)}")
    :error
  end
end
