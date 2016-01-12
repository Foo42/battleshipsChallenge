defmodule Battleships.Game do
  use GenServer
  require Logger

  defstruct mode: :placing, parameters: %Battleships.GameParameters{}

  def start_link(parameters) do
    Logger.info "starting game with params #{inspect parameters} anonymously"
    game_params = Keyword.get parameters, :game_params, %Battleships.GameParameters{}
    GenServer.start_link(__MODULE__, game_params, parameters)
  end

  def init(parameters), do: {:ok, %__MODULE__{parameters: parameters}}
end