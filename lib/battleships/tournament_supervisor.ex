defmodule Battleships.TournamentSupervisor do
  use Supervisor
  require Logger

	def start_link(opts \\ []) do
    opts = Keyword.merge([name: :tournament_supervisor], opts)
		Supervisor.start_link(__MODULE__, :ok, opts)
	end


  def start_game(supervisor, params) do
    Logger.info "#{__MODULE__} starting a child GameSupervisor with params #{inspect params}"
    params = Keyword.merge([name: :game_supervisor], params)
    case GenServer.whereis(Keyword.fetch!(params, :name)) do
      nil -> Logger.info "No previous game supervisor found with name #{inspect Keyword.fetch!(params, :name)}"
      pid ->
        :ok = Supervisor.terminate_child(supervisor, pid)
        Logger.info "previous game supervisor with name #{inspect Keyword.fetch!(params, :name)} was terminated"
    end
    Supervisor.start_child supervisor, [params]
  end

	#Implementation

	def init(:ok) do
		Logger.info "#{__MODULE__}  starting"
		supervise(children, strategy: :simple_one_for_one)
	end

  defp children() do
    [
      worker(Battleships.GameSupervisor, [], restart: :transient)
    ]
  end
end