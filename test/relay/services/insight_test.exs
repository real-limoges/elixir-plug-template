defmodule Relay.Services.InsightTest do
  use Relay.DataCase, async: true

  alias Relay.Services.InsightA

  setup do
    # Record enqueues without running the worker.
    Exq.Mock.set_mode(:fake)
    :ok
  end

  test "enqueues a job on the happy path" do
    user = insert_user()

    assert {:ok, %{job_type: "insight_a", user_id: user_id}} =
             InsightA.handle_request(%{"user_id" => user.id, "query_type" => "query_1"})

    assert user_id == user.id

    assert [job] = Exq.Mock.jobs()
    assert job.class == Relay.Worker.TaskWorker
    assert job.queue == "insight_a"
    assert [%{"job_type" => "insight_a", "user_id" => ^user_id}] = job.args
  end

  test "returns :invalid_query_type for a bad query type (no job enqueued)" do
    user = insert_user()

    assert {:error, :invalid_query_type} =
             InsightA.handle_request(%{"user_id" => user.id, "query_type" => "bogus"})

    assert Exq.Mock.jobs() == []
  end
end
