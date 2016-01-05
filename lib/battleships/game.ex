defmodule Battleships.Game do
  use GenServer
  require Logger

  defstruct mode: :placing, parameters: %Battleships.GameParameters{}

  def start_link(parameters, name) do
    Logger.info "starting game with params #{inspect parameters} with name #{inspect name}"
    GenServer.start_link(__MODULE__, parameters, name: name)
  end

  def init(parameters), do: {:ok, %__MODULE__{parameters: parameters}}
end