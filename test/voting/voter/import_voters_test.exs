defmodule Voting.ImportVotersTest do
  use Voting.DataCase, async: true

  import Voting.Factory

  alias Voting.ImportVoters

  describe "run/2" do
    test "returns the inserted, invalid, already_exist and errors" do
      %{id: election_id} = election = insert(:election)
      csv = Path.expand("../../csv/voters.csv", __DIR__)

      assert %{
               inserted: inserted,
               invalid: invalid,
               already_exist: already_exist,
               errors: errors
             } = ImportVoters.run(csv, election.id)

      assert [
               %{registration_number: "1", election_id: ^election_id},
               %{registration_number: "2", election_id: ^election_id},
               %{registration_number: "4", election_id: ^election_id}
             ] = inserted

      assert [
               %{registration_number: "5", election_id: ^election_id}
             ] = invalid

      assert [] = already_exist

      assert ["Row has length 1 - expected length 4 on line 4"] = errors

      assert %{
               inserted: inserted,
               invalid: invalid,
               already_exist: already_exist,
               errors: errors
             } = ImportVoters.run(csv, election.id)

      assert [] = inserted

      assert [
               %{registration_number: "1", election_id: ^election_id},
               %{registration_number: "2", election_id: ^election_id},
               %{registration_number: "4", election_id: ^election_id}
             ] = already_exist

      assert [
               %{registration_number: "5", election_id: ^election_id}
             ] = invalid

      assert ["Row has length 1 - expected length 4 on line 4"] = errors
    end
  end
end
