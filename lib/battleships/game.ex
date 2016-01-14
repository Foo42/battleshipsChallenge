defmodule Battleships.Game do
  alias Battleships.Grid
  alias Battleships.Grid.Coordinate
  use GenServer
  require Logger

  defstruct mode: :placing, parameters: %Battleships.GameParameters{}, all_move_results: [], my_moves: nil

  def start_link(parameters) do
    Logger.info "starting game with params #{inspect parameters} anonymously"
    game_params = Keyword.get parameters, :game_params, %Battleships.GameParameters{}
    GenServer.start_link(__MODULE__, game_params, parameters)
  end

  def get_next_move(game), do: GenServer.call game, :get_next_move

  #Implementation
  def init(parameters), do: {:ok, %__MODULE__{parameters: parameters, my_moves: Grid.new(parameters.grid_size)}}

  def handle_call(message, from, %__MODULE__{mode: :placing} = state), do: handle_call(message, from, state |> Map.put(:mode, :playing))
  def handle_call(:get_next_move, _from, state) do
    shot = Battleships.Grid.random_coordinate state.my_moves
    updated_moves = state.my_moves |> Grid.add_item shot, :shot
    Logger.info "attacking #{Coordinate.format(shot)}"
    {:reply, %{type: :attack, grid_reference: shot}, %__MODULE__{state | my_moves: updated_moves}}
  end
end