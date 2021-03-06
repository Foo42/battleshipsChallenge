defmodule Battleships.Grid.Coordinate do
  @moduledoc """
  Struct and functions for manipulating grid coordinates.
  Coordinates are stored in 0 based integer representation but can be parse/formatted back and forth from A1 based letter number combo
  """

  defstruct x: 0, y: 0

  def parse(s) do
    parts =
    ~r{(?<width>[a-z]+)(?<height>\d+)}
    |> Regex.named_captures(String.downcase(s))

    %__MODULE__{x: parse_width(parts["width"]), y: parse_height(parts["height"])}
  end

  def parse_width(width_string) do
    width =
      width_string
      |> String.to_char_list
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.reduce(0, fn ({char, position}, total) -> total + value_of_char_in_position(char, position) end)

    width - 1
  end

  def parse_height(height) do
    {value, ""} = Integer.parse(height)
    value - 1
  end

  def format(%__MODULE__{x: x, y: y}) do
    "#{to_string([x+?a])}#{to_string(y+1)}" |> String.upcase
  end

  def right_of(%__MODULE__{x: x} = coord), do: Map.put(coord, :x, x+1)
  def down_from(%__MODULE__{y: y} = coord), do: Map.put(coord, :y, y+1)

  def translate(%__MODULE__{x: x, y: y}, direction) do
    case direction do
      :up -> %__MODULE__{x: x, y: y-1}
      :down -> %__MODULE__{x: x, y: y+1}
      :left -> %__MODULE__{x: x-1, y: y}
      :right -> %__MODULE__{x: x+1, y: y}
    end
  end

  def line_from(start, :right, length) do
    start |> Stream.iterate(&right_of/1) |> Enum.take(length)
  end

  def line_from(start, :down, length) do
    start |> Stream.iterate(&down_from/1) |> Enum.take(length)
  end

  def cross_around(point, length) do
    directions = [:up, :right, :down, :left]
    directions
    |> Enum.flat_map(
      fn direction ->
        Stream.iterate(point, &translate(&1, direction))
        |> Stream.drop(1)
        |> Enum.take(length) end)
  end

  def orientation(coordinates) when is_list(coordinates) do
    orientation = case coordinates do
      [%__MODULE__{x: x} | [%__MODULE__{x: x}|_]] -> :vertical
      [%__MODULE__{y: y} | [%__MODULE__{y: y}|_]] -> :horizontal
    end
  end

  defp value_of_char(char), do: (char - ?a) + 1
  defp value_of_char_in_position(char, position), do: value_of_char(char) * round(:math.pow(26,position))
end