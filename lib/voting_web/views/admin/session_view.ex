defmodule VotingWeb.Admin.SessionView do
  use VotingWeb, :view

  def render("session.json", %{admin: admin}) do
    %{
      status: "ok",
      data: %{
        name: admin.name
      }
    }
  end
end
