defmodule Battleships.GameSupervisor do
  use Supervisor
  require Logger

	def start_link(opts \\ []) do
    game_params = Keyword.get opts, :game_params, %Battleships.GameParameters{}
		Supervisor.start_link(__MODULE__, game_params, opts)
	end

	#Implementation

	def init(%Battleships.GameParameters{} = params) do
		Logger.info "#{__MODULE__}  starting"
		supervise(children(params), strategy: :one_for_one)
	end

  defp children(game_params) do
    [
      worker(Battleships.Game, [[game_params: game_params, name: :game]]),
      worker(Battleships.ShipPlacementServer, [[game_params: game_params, name: :ship_placement_server]])
    ]
  end
end