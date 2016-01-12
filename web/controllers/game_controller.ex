defmodule Battleships.GameController do
  require Logger
  use Battleships.Web, :controller

  def start(conn, params) do
    Battleships.GameSupervisor.start_link [game_params: game_params(params), name: :game_supervisor]
    Logger.info "returning"
    json conn, %{"foo" => 42}
  end

  def place_ship(conn, params) do
  end

  def proposed_positions(conn, params) do
    Logger.info("ship placement server at #{inspect GenServer.whereis(:ship_placement_server)}")
    positions = Battleships.ShipPlacementServer.get_proposed_positions :ship_placement_server
    json conn, positions
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
