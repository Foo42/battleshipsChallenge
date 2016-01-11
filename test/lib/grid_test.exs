defmodule Battleships.GridTests do
  alias Battleships.Grid
  alias Battleships.Grid.Coordinate
  use ExUnit.Case

  test "width returns the correct width of a grid" do
    width = Grid.new("B10") |> Grid.width
    assert width == 2
  end

  test "height returns the correct height of a grid" do
    height = Grid.new("B10") |> Grid.height
    assert height == 10
  end

  test "can add items with a single coordinate" do
    grid = Grid.new("J10") |> Grid.add_item(%Coordinate{x: 0, y: 0}, "thing")
    assert length(grid.contents) == 1
  end

  test "can add items with multiple coordinates" do
    grid = Grid.new("J10") |> Grid.add_item([%Coordinate{x: 0, y: 0},%Coordinate{x: 1, y: 0},%Coordinate{x: 2, y: 0}], "thing")
    assert length(grid.contents) == 1
  end

  test "within? returns true for coordinates within the grid, and false for those outside" do
    two_by_two = Grid.new("B2")

    assert two_by_two |> Grid.within?(%Coordinate{x: 0, y: 0}) == true
    assert two_by_two |> Grid.within?(%Coordinate{x: 2, y: 2}) == false #recall coordinates are 0-based internally
  end

  test "coordinate_empty? returns true when coordinate is empty" do
    two_by_two = Grid.new("B2") |> Grid.add_item([%Coordinate{x: 0, y: 0}, %Coordinate{x: 1, y: 0}], "thing")
    assert Grid.coordinate_empty?(two_by_two, %Coordinate{x: 0, y: 1}) == true
  end

  test "coordinate_empty? returns false when coordinate is not empty" do
    two_by_two = Grid.new("B2") |> Grid.add_item([%Coordinate{x: 0, y: 0}, %Coordinate{x: 1, y: 0}], "thing")

    assert Grid.coordinate_empty?(two_by_two, %Coordinate{x: 0, y: 0}) == false
  end
end