defmodule Battleships.GameController do
  use Battleships.Web, :controller

  def start(conn, params) do
    Battleships.Game.start_link(game_params(params), :game)
    json conn, %{"foo" => 42}
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
