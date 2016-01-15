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
  def on_shot_result(game, attacker, grid_reference, result), do: GenServer.cast(game, {:on_shot_result, %{attacker: attacker, grid_reference: grid_reference, result: result}})

  #Implementation
  def init(parameters), do: {:ok, %__MODULE__{parameters: parameters, my_moves: Grid.new(parameters.grid_size)}}

  def handle_call(message, from, %__MODULE__{mode: :placing} = state) do
    Logger.info "leaving placing mode due to message #{inspect message}"
    handle_call(message, from, state |> Map.put(:mode, :hunting))
  end

  def handle_call(:get_next_move, from, %__MODULE__{mode: {:killing, killing_state}} = state) do
    case Battleships.Killing.next_move(killing_state) do
      {shot, killing_state} ->
        updated_moves = state.my_moves |> Grid.add_item shot, :shot
        Logger.info "attacking #{Coordinate.format(shot)}"
        {:reply, %{type: :attack, grid_reference: shot}, %__MODULE__{state | my_moves: updated_moves, mode: {:killing, killing_state}}}
      nil -> handle_call(:get_next_move, from, %__MODULE__{state | mode: :hunting})
    end
  end

  def handle_call(:get_next_move, _from, %__MODULE__{mode: :hunting} = state) do
    shot = Battleships.Grid.random_coordinate state.my_moves
    updated_moves = state.my_moves |> Grid.add_item shot, :shot
    Logger.info "attacking #{Coordinate.format(shot)}"
    {:reply, %{type: :attack, grid_reference: shot}, %__MODULE__{state | my_moves: updated_moves}}
  end

  def handle_cast({:on_shot_result, result}, %__MODULE__{all_move_results: previous_results} = state) do
    state = case result.attacker do
      "otpftw" ->
        case result.result do
          :hit -> hit_enemy(state, result)
          :miss -> missed_enemy(state, result)
        end
      _ -> state
    end

    mode = case state.mode do
      {:killing, nil} -> :hunting
      other -> other
    end

    {:noreply, %__MODULE__{state | all_move_results: [result | previous_results], mode: mode}}
  end

  def hit_enemy(%__MODULE__{mode: :hunting} = state, %{grid_reference: coordinate}) do
    Logger.info "entering killing mode"
    %__MODULE__{state | mode: {:killing, Battleships.Killing.begin(coordinate, state.parameters)}}
  end

  def hit_enemy(%__MODULE__{mode: {:killing, killing_state}} = state, %{grid_reference: coordinate}) do
    Logger.info "still in killing mode"
    %__MODULE__{state | mode: {:killing, Battleships.Killing.hit_enemy(killing_state, coordinate)}}
  end

  def missed_enemy(%__MODULE__{mode: {:killing, killing_state}} = state, %{grid_reference: coordinate}) do
    Logger.info "still in killing mode"
    %__MODULE__{state | mode: {:killing, Battleships.Killing.missed_enemy(killing_state, coordinate)}}
  end

  def missed_enemy(%__MODULE__{mode: :hunting} = state, %{grid_reference: coordinate}) do
    Logger.info "still in hunting mode"
    state
  end
end