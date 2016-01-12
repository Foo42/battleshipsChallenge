defmodule Battleships.Grid do
  alias Battleships.Grid.Coordinate

  defstruct bottom_right: nil, contents: []

  # Do we want to have a grid struct contain ship placements? mines? what about shots at enemy?
  # Maybe should be a sort of 2d array structure for storing other things in? Then we could have a different "grid" for each of those types of content?
  def new(%Coordinate{} = bottom_right), do: struct(__MODULE__, %{bottom_right: bottom_right})
  def new(size) when is_binary(size), do: new(Coordinate.parse(size))
  # def random_coordinate(%__MODULE__{size: size}) do
  #
  # end
  def add_item(%__MODULE__{} = grid, %Coordinate{} = position, item), do: add_item(grid, [position], item)
  def add_item(%__MODULE__{} = grid, positions, item) when is_list(positions), do: Map.put(grid, :contents, [{positions, item} | grid.contents])

  def width(%__MODULE__{bottom_right: %{x: x}}), do: x+1
  def height(%__MODULE__{bottom_right: %{y: y}}), do: y+1

  def within?(%__MODULE__{bottom_right: %Coordinate{x: max_x, y: max_y}}, %Coordinate{x: x, y: y} = coordinate) do
    x <= max_x && y <= max_y
  end

  def random_coordinate(%__MODULE__{bottom_right: bottom_right}) do
    %Coordinate{x: max_x, y: max_y} = bottom_right
    x = 0..max_x |> Enum.random
    y = 0..max_y |> Enum.random
    %Coordinate{x: x, y: y}
  end

  def coordinate_empty?(%__MODULE__{contents: contents} = grid, coordinate) do
    occupied =
      contents
      |> Stream.flat_map(fn {positions,_} -> positions end)
      |> Enum.any? &(&1 == coordinate)

    !occupied
  end
  # 
  # def all_positions(%__MODULE__{bottom_right: bottom_right}) d
  # end
  #
  # def as_ascii(%__MODULE__{bottom_right: bottom_right, contents: contents}) do
  #
  # end
end