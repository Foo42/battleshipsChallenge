defmodule Battleships.GameController do
  require Logger
  use Battleships.Web, :controller

  def start(conn, params) do
    Battleships.TournamentSupervisor.start_game :tournament_supervisor, [game_params: game_params(params)]
    Logger.info "returning"
    json conn, %{"foo" => 42}
  end

  def confirm_ship_placements(conn, params) do
    positions = params["gridReferences"] |> Enum.map &Battleships.Grid.Coordinate.parse/1
    Logger.info "Ship confirmed position at #{inspect positions}"
    json conn, %{}
  end

  defp game_params(params), do: params |> Enum.map(&map_param/1) |> Enum.reject(&(&1 == nil)) |> Enum.into(%{}) |> Battleships.GameParameters.from_dict

  defp map_param({key, value}), do: {map_key(key), value}

  defp map_key(key) do
    case key do
      "maxTurns" -> :max_turns
      "gridSize" -> :grid_size
      "players" -> :players
      "ships" -> :ships
      "mineCount" -> :mine_count
      _ -> nil
    end
  end


end
