ExUnit.start()

# Route Exq enqueues through the in-memory mock (no Redis). Default :fake mode
# records jobs without running them; tests can switch to :inline if needed.
{:ok, _} = Exq.Mock.start_link(mode: :fake)

Ecto.Adapters.SQL.Sandbox.mode(Relay.Repo, :manual)
