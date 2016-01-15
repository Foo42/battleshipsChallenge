defmodule Battleships.Grid.CoordinateTests do
  alias Battleships.Grid.Coordinate
  use ExUnit.Case

  test "origin cell parses to 0-based coordinate" do
    coord = Coordinate.parse("A1")
    assert coord.x == 0
    assert coord.y == 0
  end

  test "other cell parses" do
    coord = Coordinate.parse("E8")
    assert coord.x == 4
    assert coord.y == 7
  end

  test "format produces a1 based string" do
    assert Coordinate.parse("E8") |> Coordinate.format() == "E8"
  end

  test "right_of returns a coordinate which is to the right of given" do
    assert Coordinate.right_of(Coordinate.parse("A1")) |> Coordinate.format() == "B1"
  end

  test "down_from returns a coordinate which is down from given" do
    assert Coordinate.down_from(Coordinate.parse("A1")) |> Coordinate.format() == "A2"
  end

  test "line_from returns a list of coordinates of requested length in requested direction" do
    line_to_the_right = Coordinate.line_from(%Coordinate{x: 0, y: 0}, :right, 3)
    assert line_to_the_right == [%Coordinate{x: 0, y: 0}, %Coordinate{x: 1, y: 0}, %Coordinate{x: 2, y: 0}]

    line_down = Coordinate.line_from(%Coordinate{x: 0, y: 0}, :down, 3)
    assert line_down == [%Coordinate{x: 0, y: 0}, %Coordinate{x: 0, y: 1}, %Coordinate{x: 0, y: 2}]
  end

  test "cross_around should return a cross of coordinates with specified arm length" do
    centre = Coordinate.parse("C3")
    cross = Coordinate.cross_around centre, 2
    assert cross |> Enum.map(&Coordinate.format/1) == ["C2", "C1", "D3", "E3", "C4", "C5", "B3", "A3"]
  end
end