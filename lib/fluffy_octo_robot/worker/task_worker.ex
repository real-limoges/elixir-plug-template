defmodule FluffyOctoRobot.Worker.TaskWorker do
  alias FluffyOctoRobot.ModelRunner

  def perform(%{"job_type" => "insight_a", "data" => data, "model_name" => model, "user_id" => user_id}) do
    IO.puts("[Worker] Starting Insight A for user: #{user_id}")

    with {:ok, prediction} <- ModelRunner.run(model, data) do
      IO.puts("[Worker] successfully did Insight A. #{inspect(prediction)}")
      :ok
    else
      {:error, reason} -> IO.puts("[Worker] failed for Insight A: #{inspect(reason)}")
      :error
    end

  end

  def perform(%{"job_type" => "insight_b", "data" => data, "model_name" => model, "user_id" => user_id}) do
    IO.puts("[Worker] Starting Insight B for user: #{user_id}")

    with {:ok, prediction} <- ModelRunner.run(model, data) do
      IO.puts("[Worker] successfully did Insight B. #{inspect(prediction)}")
      :ok
    else
      {:error, reason} -> IO.puts("[Worker] failed for Insight B: #{inspect(reason)}")
      :error
    end
  end

  def perform(mystery_payload) do
    IO.puts("[Worker] received an unknown payload. #{inspect(mystery_payload)}")
    :error
  end
end
