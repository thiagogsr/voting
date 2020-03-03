defmodule Voting.CreateElection do
  @moduledoc """
  Creating an election
  """

  import Ecto.Changeset

  alias Voting.{Election, Repo}

  def run(params) do
    %Election{}
    |> cast(params, [:name, :cover, :notice, :starts_at, :ends_at, :created_by_id])
    |> validate_required([:name, :starts_at, :ends_at, :created_by_id])
    |> validate_dates_overlap()
    |> foreign_key_constraint(:created_by_id)
    |> Repo.insert()
  end

  defp validate_dates_overlap(%Ecto.Changeset{valid?: true} = changeset) do
    %{starts_at: starts_at, ends_at: ends_at} = changeset.changes

    case DateTime.compare(starts_at, ends_at) do
      :gt -> add_error(changeset, :starts_at, "should be before ends_at")
      _ -> changeset
    end
  end

  defp validate_dates_overlap(%Ecto.Changeset{} = changeset), do: changeset
end
