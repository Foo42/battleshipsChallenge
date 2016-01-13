defmodule Battleships.PlacementController do
  alias Battleships.ShipPlacementServer
  alias Battleships.Grid.Coordinate
  require Logger
  use Battleships.Web, :controller

  def get_placement(conn, %{"type" => ship_type}) do
    {position_array, _} = ShipPlacementServer.pop_position :ship_placement_server, String.upcase(ship_type)
    orientation = case position_array do
      [%Coordinate{x: x} | [%Coordinate{x: x}|_]] -> "vertical"
      [%Coordinate{y: y} | [%Coordinate{y: y}|_]] -> "horizontal"
    end
    anchor = position_array |> Stream.map(&Coordinate.format/1) |> Enum.at 0
    json conn, %{"gridReference" => anchor, "orientation" => orientation}
  end

  def proposed_positions(conn, params) do
    Logger.info("ship placement server at #{inspect GenServer.whereis(:ship_placement_server)}")
    positions = Battleships.ShipPlacementServer.get_proposed_positions :ship_placement_server
    json conn, positions
  end
end
