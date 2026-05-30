defmodule Relay.DataSourceTest do
  use Relay.DataCase, async: true

  alias Relay.DataSource

  describe "fetch_data/2" do
    test "returns rows for a known user and a valid query type" do
      user = insert_user()

      assert {:ok, [row]} = DataSource.fetch_data(user.id, :query_1)
      assert row.user_id == user.id
    end

    test "returns :not_found when the user does not exist" do
      assert {:error, :not_found} = DataSource.fetch_data(-1, :query_1)
    end

    test "returns :invalid_query_type for an unknown query type" do
      user = insert_user()

      assert {:error, :invalid_query_type} = DataSource.fetch_data(user.id, :bogus)
    end
  end
end
