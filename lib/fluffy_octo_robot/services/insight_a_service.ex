defmodule FluffyOctoRobot.Services.InsightAService do
  @moduledoc "This is a stub of a service, where some business logic would go."

  alias FluffyOctoRobot.Pipeline
  alias FluffyOctoRobot.Workers.TaskWorker

  @queue_name "default"

  def handle_request(%{"user_id" => user_id, "query_type" => query_type}) do
    with {:ok, feature_vector} <- Pipeline.run_for_user(user_id, query_type) do
      job_payload = %{
        job_type: "insight_a",
        model_name: "insight_a_model",
        data: feature_vector
      }

      Exq.enqueue!(TaskWorker, @queue_name, [job_payload])

      {:ok, %{job_type: "insight_a", user_id: user_id}}
    end
  end
end
