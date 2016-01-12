defmodule Battleships.ShipPlacementServer do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    Logger.info "starting #{__MODULE__} with opts #{inspect opts}"
    game_params = Keyword.get opts, :game_params, %Battleships.GameParameters{}
    GenServer.start_link(__MODULE__, game_params, opts)
  end

  def init(parameters) do
    GenServer.cast self, {:calculate_placements}
    {:ok, %{game_params: parameters}}
  end

  def get_proposed_positions(pid) do
    GenServer.call(pid, {:get_proposed_positions})
  end

  def handle_cast({:calculate_placements}, %{game_params: game_params} = state) do
    Logger.info "Begun calculating placements"
    placements =
      game_params
      |> Battleships.PlaceShips.for_game()
      |> Map.get(:contents)
      |> Enum.group_by(fn {positions, type} -> type end)
      |> Enum.map(fn {ship_type, instances} -> {ship_type, Enum.map(instances, fn {positions, _} -> Enum.map(positions, &Battleships.Grid.Coordinate.format/1) end)} end)
      |> Enum.into %{}

    {:noreply, state |> Map.put(:placements, placements)}
  end

  def handle_call({:get_proposed_positions}, _from, %{placements: placements} = state) do
    {:reply, placements, state}
  end
end