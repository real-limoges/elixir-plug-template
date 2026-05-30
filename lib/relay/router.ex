defmodule Relay.Router do
  @moduledoc """
  HTTP transport layer: a `Plug.Router` served by Bandit.

  Responsibilities are deliberately narrow: parse/validate params, call exactly
  one service, and map `{:ok, _} | {:error, reason}` onto an HTTP status + JSON.
  No business logic and no database access live here. Error→status mapping is
  centralized in `send_error/2`.
  """

  use Plug.Router

  alias Relay.Services.InsightA
  alias Relay.Services.InsightB

  # Parse JSON bodies into string-keyed maps before routing.
  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason

  plug :match
  plug :dispatch

  post "/api/insights/a" do
    handle(conn, InsightA)
  end

  post "/api/insights/b" do
    handle(conn, InsightB)
  end

  match _ do
    send_error(conn, :not_found)
  end

  # Calls exactly one service with the parsed body and renders the result.
  defp handle(conn, service) do
    case service.handle_request(conn.body_params) do
      {:ok, result} -> send_json(conn, 202, result)
      {:error, reason} -> send_error(conn, reason)
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end

  # The single place where internal error reasons become HTTP statuses.
  defp send_error(conn, reason) do
    {status, message} = error_to_status(reason)
    send_json(conn, status, %{error: message})
  end

  defp error_to_status(:not_found), do: {404, "not_found"}
  defp error_to_status(:invalid_query_type), do: {422, "invalid_query_type"}
  defp error_to_status(:invalid_params), do: {422, "invalid_params"}
  defp error_to_status(reason) when is_binary(reason), do: {500, reason}
  defp error_to_status(_reason), do: {500, "internal_error"}
end
