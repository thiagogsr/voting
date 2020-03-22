defmodule Voting.AdminRepo do
  @moduledoc """
  Admin repository
  """

  alias Voting.{Admin, Repo}

  def get_admin!(id) do
    Repo.get!(Admin, id)
  end
end
