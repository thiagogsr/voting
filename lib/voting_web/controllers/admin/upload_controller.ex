defmodule VotingWeb.Admin.UploadController do
  use VotingWeb, :controller

  alias Voting.Uploader

  def create(conn, %{"file" => file}) do
    case Uploader.run(file) do
      {:ok, url} ->
        json(conn, %{status: "ok", data: %{url: url}})

      {:error, error} ->
        conn
        |> put_status(400)
        |> json(%{status: error})
    end
  end
end
