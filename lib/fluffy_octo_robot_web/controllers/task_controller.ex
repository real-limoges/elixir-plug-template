defmodule FluffyOctoRobotWeb.TaskController do

    use FluffyOctoRobotWeb, :controller

    alias FluffyOctoRobot.Services.InsightAService
    alias FluffyOctoRobot.Services.InsightBService

    def run_insight_a(conn, params) do
      case InsightAService.handle_request(params) do
        {:ok, result} ->
            conn
            |> put_status(:accepted)
            |> json(%{status: "ok", result: result})
        {:error, reason} ->
            handle_error(conn, reason)
      end
    end

    def run_insight_b(conn, params) do
      case InsightBService.handle_request(params) do
        {:ok, result} ->
            conn
            |> put_status(:accepted)
            |> json(%{status: "ok", result: result})
        {:error, reason} ->
            handle_error(conn, reason)
      end
    end

    # error helpers
    defp handle_error(conn, :not_found), do:
        conn |> put_status(:not_found) |> json(%{error: "User data not found"})
    defp handle_error(conn, :invalid_query_type), do:
        conn |> put_status(:bad_request) |> json(%{error: "Invalid query type"})
    defp handle_error(conn, reason) when is_binary(reason), do:
        conn |> put_status(:unprocessable_entity) |> json(%{error: "Failed to process data: #{reason}"})
    defp handle_error(conn, reason), do:
        conn |> put_status(:internal_server_error) |> json(%{error: inspect(reason)})
end
