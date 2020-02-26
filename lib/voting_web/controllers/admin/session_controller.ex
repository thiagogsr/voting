defmodule VotingWeb.Admin.SessionController do
  use VotingWeb, :controller

  alias Voting.SignInAdmin

  def create(conn, %{"email" => email, "password" => password}) do
    case SignInAdmin.run(email, password) do
      {:ok, admin} ->
        render(conn, "session.json", %{admin: admin})

      {:error, _} ->
        conn
        |> put_status(401)
        |> json(%{status: "unauthenticated"})
    end
  end
end
