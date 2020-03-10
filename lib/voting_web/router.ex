defmodule VotingWeb.Router do
  use VotingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_as_admin do
    plug :accepts, ["json"]
    plug VotingWeb.AuthAccessPipeline
  end

  scope "/api/v1", VotingWeb do
    pipe_through :api

    post("/admin/sign_in", Admin.SessionController, :create)
  end

  scope "/api/v1", VotingWeb do
    pipe_through :api_as_admin

    post("/elections", Admin.ElectionController, :create)
    post("/uploads", Admin.UploadController, :create)
  end
end
