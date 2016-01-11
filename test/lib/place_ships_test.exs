defmodule Battleships.PlaceShipsTest do
  alias Battleships.PlaceShips
  alias Battleships.Grid
  use ExUnit.Case

  test "after placing, the grid contains the correct amount of ships" do
    ships = ["FRIGATE", "GUNBOAT"]
    placements = PlaceShips.for_game %Battleships.GameParameters{ships: ships, grid_size: "J10"}
    assert length(placements.contents) == length(ships)
  end

  test "Ships occupy more than one coordinate when placed" do
    ships = ["GUNBOAT"]
    placements = PlaceShips.for_game %Battleships.GameParameters{ships: ships, grid_size: "J10"}
    [{positions,"GUNBOAT"}] = placements.contents
    assert length(positions) > 1
  end

  test "Ships are not placed in the same place" do
    ships = ["GUNBOAT","GUNBOAT"]
    placements = PlaceShips.for_game %Battleships.GameParameters{ships: ships, grid_size: "J10"}
    [{a_coordinates, _}, {b_coordinates, _}] = placements.contents
    assert a_coordinates != b_coordinates
  end
end