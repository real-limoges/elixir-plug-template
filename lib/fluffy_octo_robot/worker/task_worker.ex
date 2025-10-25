defmodule FluffyOctoRobot.Worker.TaskWorker do
  use Exq.Worker
  alias FluffyOctoRobot.ModelRunner

  @queue "default"

  @impl true
  def perform(%{"job_type" => "insight_a", "data" => data, "model_name" => model}) do
    user_id = data["user_id"]
    IO.puts("[Worker] Starting Insight A for user: #{user_id}")

    with {:ok, prediction} <- ModelRunner.run(model, data) do
      IO.puts("[Worker] successfully did Insight A. #{inspect(prediction)}")
      :ok
    else
      {:error, reason} -> IO.puts("[Worker] failed for Insight A: #{inspect(prediction)}")
      :error
    end

  end

  @impl true
  def perform(%{"job_type" => "insight_a", "data" => data, "model_name" => model}) do
    user_id = data["user_id"]
    IO.puts("[Worker] Starting Insight B for user: #{user_id}")

    with {:ok, prediction} <- ModelRunner.run(model, data) do
      IO.puts("[Worker] successfully did Insight B. #{inspect(prediction)}")
      :ok
    else
      {:error, reason} -> IO.puts("[Worker] failed for Insight B: #{inspect(prediction)}")
      :error
    end
  end

  @impl true
  def perform(mystery_payload) do
    IO.puts("[Worker] received an unknown payload. #{inspect(mystery_payload)}")
    :error
  end
end
