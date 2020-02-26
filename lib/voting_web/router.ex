defmodule VotingWeb.Router do
  use VotingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", VotingWeb do
    pipe_through :api

    post("/admin/sign_in", Admin.SessionController, :create)
  end
end
