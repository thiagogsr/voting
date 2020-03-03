defmodule VotingWeb.Admin.SessionController do
  use VotingWeb, :controller

  alias Voting.SignInAdmin
  alias VotingWeb.Guardian

  def create(conn, %{"email" => email, "password" => password}) do
    case SignInAdmin.run(email, password) do
      {:ok, admin} ->
        {:ok, token, _} = Guardian.encode_and_sign(admin)
        render(conn, "session.json", %{admin: admin, token: token})

      {:error, _} ->
        conn
        |> put_status(401)
        |> json(%{status: "unauthenticated"})
    end
  end
end
