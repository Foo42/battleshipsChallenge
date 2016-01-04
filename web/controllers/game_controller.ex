defmodule Battleships.GameController do
  use Battleships.Web, :controller

  def start(conn, %{"maxTurns" => max_turns}) do
    Battleships.Game.start_link(%Battleships.Game{max_turns: max_turns}, :game)
    json conn, %{"foo" => 42}
  end
end
