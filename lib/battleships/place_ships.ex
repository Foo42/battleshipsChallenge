defmodule Battleships.PlaceShips do
  alias Battleships.ShipTypes
  alias Battleships.Grid
  alias Battleships.Grid.Coordinate
  require Logger

  def for_game(parameters = %Battleships.GameParameters{grid_size: grid_size}), do: for_game(parameters, Grid.new(grid_size))
  def for_game(%Battleships.GameParameters{ships: ships}, grid) do
    ships
    |> sort_ships
    |> place_ships(grid)
  end

  defp sort_ships(ships), do: Enum.sort_by(ships, &ShipTypes.size_of/1)

  defp place_ships(ships, grid) do
    ships
    |> Enum.reduce(grid, &place_ship/2)
  end

  defp place_ship(ship, grid) do
    all_positions_available? = fn positions -> Enum.all?(positions, &Grid.coordinate_empty?(grid, &1)) end
    coordinates =
      Stream.repeatedly(fn -> propose_ship_position(ship, grid) end)
      |> Stream.filter(all_positions_available?)
      |> Enum.at 0

    grid |> Grid.add_item(coordinates, ship)
  end

  defp random_orientation, do: [:right, :down] |> Enum.random
  defp propose_ship_position(ship, grid) do
    ship_size = ShipTypes.size_of(ship)
    suggest_positions = fn -> Grid.random_coordinate(grid) |> Coordinate.line_from(random_orientation, ship_size) end
    all_positions_valid? = fn positions -> positions |> Enum.all? &Grid.within?(grid, &1) end

    {positions, required_iterations} =
      Stream.repeatedly(suggest_positions)
      |> Stream.with_index
      |> Stream.filter(fn {positions, _} -> all_positions_valid?.(positions) end)
      |> Enum.at 0
    Logger.info("placed #{ship} in #{required_iterations} iterations")
    positions
  end
end