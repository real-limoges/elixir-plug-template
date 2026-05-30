defmodule Relay.PipelineTest do
  use Relay.DataCase, async: true

  alias Relay.Pipeline

  test "ok path returns a feature vector derived from the user's rows" do
    user = insert_user()

    assert {:ok, [row]} = Pipeline.run_for_user(user.id, :query_1)
    # DataProcess increments user_id as its stub transform.
    assert row["user_id"] == user.id + 1
  end

  test "short-circuits when the data source returns an error" do
    # An invalid query type fails in DataSource; DataProcess is never reached.
    assert {:error, :invalid_query_type} = Pipeline.run_for_user(1, :bogus)
  end
end
