defmodule Battleships.Router do
  use Battleships.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Battleships do
    pipe_through :api

    post "/START", GameController, :start
    get "/PLACE", PlacementController, :get_placement

    scope "/internals" do
      get "/plannedpositions", PlacementController, :proposed_positions
    end
  end

  scope "/", Battleships do
    pipe_through :browser

    get "/", PageController, :index
  end
  # Other scopes may use custom stacks.
  # scope "/api", Battleships do
  #   pipe_through :api
  # end
end
