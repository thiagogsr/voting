defmodule Voting.UpdateElection do
  @moduledoc """
  Updating an election
  """

  import Ecto.Changeset
  import Voting.DatesOverlap

  alias Voting.{Election, Repo}

  def run(%Election{} = election, params) do
    election
    |> cast(params, [:name, :cover, :notice, :starts_at, :ends_at])
    |> validate_required([:name, :starts_at, :ends_at])
    |> validate_dates_overlap(:starts_at, :ends_at)
    |> Repo.update()
  end
end
