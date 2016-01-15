defmodule Battleships.Hunting do
  alias Battleships.Grid
  alias Battleships.Grid.Coordinate
  require Logger

  def suggest_shot(previous_shot_grid) do
    random_unused_coordinate(previous_shot_grid, with_clearance_of: 3, max_tries: 20)
    |> Stream.concat(random_unused_coordinate(previous_shot_grid, with_clearance_of: 2, max_tries: 20))
    |> Stream.concat(random_unused_coordinate(previous_shot_grid))
    |> Enum.at(0)
  end

  def random_unused_coordinate(previous_shot_grid) do
      Stream.repeatedly(fn -> Grid.random_coordinate(previous_shot_grid)end)
      |> Stream.filter(&Grid.coordinate_empty?(previous_shot_grid, &1))
      # |> Stream.each(&Logger.info("proposing shot at #{Coordinate.format(&1)} with previous of #{inspect(Enum.map(previous_shot_grid.contents,fn {[pos|_],_} -> Coordinate.format(pos)end))}"))
  end

  def random_unused_coordinate(previous_shot_grid, [with_clearance_of: clearance, max_tries: max_tries]) do
    random_unused_coordinate(previous_shot_grid)
    |> Stream.take(max_tries)
    |> Stream.filter(&position_clear(&1, previous_shot_grid, with_clearance_of: clearance))
  end

  defp position_clear(coordinate, previous_shot_grid, [with_clearance_of: clearance]) do
    surrounding_positions =
      Coordinate.cross_around(coordinate, clearance)
      |> Enum.filter(&Grid.within?(previous_shot_grid,&1))

    positions_clear =
      surrounding_positions
      |> Enum.all?(fn nearby -> Grid.coordinate_empty?(previous_shot_grid, nearby) end)

    positions_clear
  end
end