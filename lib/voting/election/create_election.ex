defmodule Voting.CreateElection do
  @moduledoc """
  Creating an election
  """

  import Ecto.Changeset
  import Voting.DatesOverlap

  alias Voting.{Election, Repo}

  def run(params) do
    %Election{}
    |> cast(params, [:name, :cover, :notice, :starts_at, :ends_at, :created_by_id])
    |> validate_required([:name, :starts_at, :ends_at, :created_by_id])
    |> validate_dates_overlap(:starts_at, :ends_at)
    |> foreign_key_constraint(:created_by_id)
    |> Repo.insert()
  end
end
