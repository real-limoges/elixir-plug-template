# elixir-plug-template (`Relay`)

A ready-to-use template for an Elixir **JSON API backend with background jobs** —
plain **Plug + Bandit** (no Phoenix), **Ecto/Postgres**, **Exq** (Redis-backed jobs),
and **Explorer/Nx** for the data layer. It demonstrates clean, legible boundaries
between transport, business, and data layers so you can drop in your own logic and
ship. The internal app is named `Relay`; the repo is named for discoverability.

## The pattern

A request becomes an asynchronous, queued job through a strict layered pipeline:

```
POST /api/insights/{a|b}
  → Relay.Router (Plug.Router on Bandit)     transport: parse params → service → JSON
    → Relay.Services.Insight{A,B}            business capability: orchestrate + enqueue
      → Relay.Pipeline                       reusable orchestration, a `with` chain
        → Relay.DataSource                   all Ecto/Postgres access (schema-based)
        → Relay.DataProcess                  pure transform via Explorer dataframes → feature vector
      → Exq.enqueue(...)                      async boundary
  ← 202 Accepted                              returns immediately

[async] Relay.Worker.TaskWorker.perform/1
          → Relay.ModelRunner.run/2          runs the model, returns a prediction
```

Business logic (`ModelRunner`, the `DataProcess` transform) ships as clearly-labelled
stubs — the layering and the happy path are real and run end-to-end.

## Setup

Prerequisites: Elixir ~> 1.19, **PostgreSQL**, and **Redis** (for Exq).

```bash
mix setup        # deps.get + create DB + migrate + seed a sample user (id 1)
iex -S mix       # boots the Bandit listener on http://localhost:4000
```

Postgres connection and the HTTP port are configured in `config/dev.exs` and
`config/config.exs` (`PORT` env var overrides the port at runtime).

## Try it

With Redis and the app running:

```bash
curl -i -X POST localhost:4000/api/insights/a \
  -H 'content-type: application/json' \
  -d '{"user_id": 1, "query_type": "query_1"}'
```

You get `202 Accepted` with `{"job_type":"insight_a","user_id":1}` immediately, and
the worker processes the job asynchronously — watch the `[Worker]` / `[ModelRunner]`
lines in the iex logs. `query_type` accepts `query_1`, `query_2`, or `query_3`; an
unknown value returns `422`.

## Quality gate

```bash
mix precommit    # compile (warnings as errors) + format + credo --strict + dialyzer + test
```

Keep this green. Tests run without Redis (Exq is mocked) and use an Ecto SQL sandbox.

## Using this as a starting point

1. Read `CLAUDE.md` — it documents the layer responsibilities and conventions.
2. Rename `Relay` / `:relay` to your service name (module names, `mix.exs` `app:`,
   config keys, `lib/relay/` directory).
3. Replace the stubs: real reads in `Relay.DataSource`, real feature engineering in
   `Relay.DataProcess`, real inference in `Relay.ModelRunner`.
4. Add capabilities by copying a thin service (`Relay.Services.InsightA`), adding a
   route, and adding its queue — see "Adding a new insight" in `CLAUDE.md`.
