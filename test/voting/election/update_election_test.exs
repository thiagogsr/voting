defmodule Voting.UpdateElectionTest do
  use Voting.DataCase, async: true

  alias Voting.{Election, UpdateElection}

  import Voting.Factory

  describe "run/1" do
    test "returns a struct when the params are valid" do
      admin = insert(:admin)
      election = insert(:election, created_by: admin)

      params = %{
        name: "New name",
        cover: "New cover",
        notice: "New notice"
      }

      assert {:ok, %Election{} = election} = UpdateElection.run(election, params)
      assert election.name == "New name"
      assert election.cover == "New cover"
      assert election.notice == "New notice"
      assert election.created_by_id == admin.id
    end

    test "returns error when name is missing" do
      election = insert(:election)

      params = %{name: ""}

      assert {:error, %Ecto.Changeset{} = changeset} = UpdateElection.run(election, params)
      %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when starts_at is missing" do
      election = insert(:election)

      params = %{starts_at: nil}

      assert {:error, %Ecto.Changeset{} = changeset} = UpdateElection.run(election, params)
      %{starts_at: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when ends_at is missing" do
      election = insert(:election)

      params = %{ends_at: nil}

      assert {:error, %Ecto.Changeset{} = changeset} = UpdateElection.run(election, params)
      %{ends_at: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when starts_at is greater than ends_at" do
      election = insert(:election)

      params = %{starts_at: ~U[2020-03-01 11:00:00Z], ends_at: ~U[2020-02-29 20:59:59Z]}

      assert {:error, %Ecto.Changeset{} = changeset} = UpdateElection.run(election, params)
      %{starts_at: ["should be before ends_at"]} = errors_on(changeset)
    end
  end
end
