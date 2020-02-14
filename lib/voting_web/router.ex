defmodule VotingWeb.Router do
  use VotingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", VotingWeb do
    pipe_through :api
  end
end
