defmodule VotingWeb.Admin.SessionView do
  use VotingWeb, :view

  def render("session.json", %{admin: admin, token: token}) do
    %{
      status: "ok",
      data: %{
        name: admin.name,
        token: token
      }
    }
  end
end
