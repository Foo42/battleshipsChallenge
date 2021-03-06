defmodule Battleships.Killing do
  require Logger
  alias Battleships.Grid.Coordinate
  defstruct known_positions: [], orientation: :unknown, first_hit: nil, game_parameters: %Battleships.GameParameters{}

  def begin(initial_hit_coordinate, %Battleships.GameParameters{} = game_params) do
    %__MODULE__{}
    |> Map.put(:known_positions, [initial_hit_coordinate])
    |> Map.put(:first_hit, initial_hit_coordinate)
    |> Map.put(:game_parameters, game_params)
    |> Map.put(:orientation, {:unknown, suggest_orientation_tests(initial_hit_coordinate, Battleships.Grid.new(game_params.grid_size))})
  end

  def next_move(%__MODULE__{orientation: {:unknown, tests}} = killing_state) do
    [{next,hypothesis} | other_tests] = tests
    Logger.info "first hit was at #{Coordinate.format(killing_state.first_hit)}, so trying #{Coordinate.format(next)} to test hypothesis #{hypothesis}"
    {next, killing_state}
  end

  def next_move(%__MODULE__{orientation: {orientation, directions}} = killing_state) when is_list(directions) do
    case directions do
      [] ->
        nil
      [direction_to_move | _] ->
        [last_hit|_] = killing_state.known_positions
        next = Coordinate.translate(last_hit, direction_to_move)
        allowed_grid = Battleships.Grid.new(killing_state.game_parameters.grid_size)
        case Battleships.Grid.within?(allowed_grid, next) do
          true -> {next, killing_state}
          false -> :nil
        end
    end
  end

  def hit_enemy(%__MODULE__{orientation: {:unknown, [{coordinate, hypothesis}|_]}} = killing_state, coordinate) do
    Logger.info "ship appears to be in #{hypothesis} orientation"
    killing_state
    |> Map.put(:orientation, {hypothesis, directions_for(hypothesis)})
    |> Map.put(:known_positions, [coordinate | killing_state.known_positions])
  end

  def hit_enemy(%__MODULE__{orientation: _} = killing_state, coordinate) do
    killing_state
    |> Map.put(:known_positions, [coordinate | killing_state.known_positions])
  end

  def missed_enemy(%__MODULE__{orientation: {:unknown, [_|remaining_hypothesis]}} = killing_state, coordinate) do
    killing_state
    |> Map.put(:orientation, {:unknown, remaining_hypothesis})
  end

  def missed_enemy(%__MODULE__{orientation: {orientation, directions}} = killing_state, coordinate) do
    [_current_direction | other_directions] = directions
    killing_state |> Map.put(:orientation, {orientation, other_directions})
  end

  defp suggest_orientation_tests(initial, grid) do
    [{:up, :vertical}, {:down, :vertical}, {:left, :horizontal}, {:right, :horizontal}]
    |> Enum.shuffle
    |> Enum.map(fn {direction, hypothesis} -> {Coordinate.translate(initial, direction),hypothesis} end)
    |> Enum.filter(fn {coordinate, _} -> Battleships.Grid.within?(grid, coordinate) end)
  end

  defp directions_for(:vertical), do: [:up, :down] |> Enum.shuffle
  defp directions_for(:horizontal), do: [:left, :right] |> Enum.shuffle

end