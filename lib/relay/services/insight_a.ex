defmodule Relay.Services.InsightA do
  @moduledoc """
  The "insight A" business capability. A thin entry point: it declares its
  `job_type`/`model_name` and delegates orchestration to `Relay.Services.Insight`.
  Returns plain maps/tuples and never touches `conn`.
  """

  alias Relay.Services.Insight

  @job_type "insight_a"
  @model_name "insight_a_model"

  @spec handle_request(map()) :: {:ok, map()} | {:error, term()}
  def handle_request(params), do: Insight.enqueue(@job_type, @model_name, params)
end
