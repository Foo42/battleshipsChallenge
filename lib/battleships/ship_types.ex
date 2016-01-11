defmodule Battleships.ShipTypes do
  def size_of("CARRIER"), do: 5
  def size_of("DESTROYER"), do: 4
  def size_of("FRIGATE"), do: 3
  def size_of("GUNBOAT"), do: 2
end