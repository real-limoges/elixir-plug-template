defmodule FluffyOctoRobot.Services.InsightBService do
  @moduledoc "This is a stub of a service, where some business logic would go."

  alias FluffyOctoRobot.Pipeline
  alias FluffyOctoRobot.Worker.TaskWorker

  @queue_name "default"

  def handle_request(%{"user_id" => user_id, "query_type" => query_type}) do
    with {:ok, feature_vector} <- Pipeline.run_for_user(user_id, query_type) do
      job_payload = %{
        job_type: "insight_b",
        model_name: "insight_b_model",
        user_id: user_id,
        data: feature_vector
      }

      Exq.enqueue(Exq, TaskWorker, [job_payload], [queue: @queue_name])

      {:ok, %{job_type: "insight_b", user_id: user_id}}
    end
  end
end
