defmodule Battleships.GameParameters do
  defstruct max_turns: 0, grid_size: nil, ships: [], players: [], mine_count: 0
  def from_dict(dict), do: struct(__MODULE__, dict)
end