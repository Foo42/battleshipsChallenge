defmodule Battleships.ShipPlacementServerTests do
  alias Battleships.ShipPlacementServer
  use ExUnit.Case

  test "pop_position returns next position for ship of given type and updates internal state" do
    initial_state = %{
      awaiting_placement: %{
        "FRIGATE" => ["a","b"],
        "CARRIER" => ["c","d"]
      }
    }
    {:reply, ship, state} = ShipPlacementServer.handle_call({:pop_position, "FRIGATE"}, self, initial_state)
    assert ship == "a"
    assert state == %{
      awaiting_placement: %{
        "FRIGATE" => ["b"],
        "CARRIER" => ["c","d"]
      }
    }
  end
end