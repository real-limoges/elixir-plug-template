defmodule Relay.RouterTest do
  use Relay.DataCase, async: true

  import Plug.Test
  import Plug.Conn

  alias Relay.Router

  @opts Router.init([])

  setup do
    Exq.Mock.set_mode(:fake)
    :ok
  end

  defp post_json(path, body) do
    :post
    |> conn(path, Jason.encode!(body))
    |> put_req_header("content-type", "application/json")
    |> Router.call(@opts)
  end

  test "POST /api/insights/a returns 202 with the job info as JSON" do
    user = insert_user()

    conn = post_json("/api/insights/a", %{"user_id" => user.id, "query_type" => "query_1"})

    assert conn.status == 202
    assert {:ok, %{"job_type" => "insight_a", "user_id" => _}} = Jason.decode(conn.resp_body)
  end

  test "maps an invalid query type to 422" do
    user = insert_user()

    conn = post_json("/api/insights/a", %{"user_id" => user.id, "query_type" => "bogus"})

    assert conn.status == 422
    assert {:ok, %{"error" => "invalid_query_type"}} = Jason.decode(conn.resp_body)
  end

  test "unknown routes return 404" do
    conn = post_json("/nope", %{})

    assert conn.status == 404
  end
end
