defmodule Voting.ImportVoters do
  @moduledoc """
  Importing voters from a CSV file
  """

  alias Voting.{ElectionRepo, Repo, Voter}

  import Ecto.Changeset

  def run(file, election_id) do
    election = ElectionRepo.get_election!(election_id)
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    rows =
      file
      |> File.stream!()
      |> CSV.decode(headers: true)
      |> Stream.map(fn row ->
        case row do
          {:ok, voter} -> {:ok, build_entry(voter, election.id, now)}
          {:error, error} -> {:error, error}
        end
      end)
      |> Enum.to_list()

    entries =
      rows
      |> Keyword.get_values(:ok)
      |> validate_entries()
      |> find_voters()
      |> insert_entries()

    %{
      inserted: entries.inserted,
      invalid: entries.invalid,
      already_exist: entries.already_exist,
      errors: Keyword.get_values(rows, :error)
    }
  end

  defp build_entry(voter, election_id, now) do
    %{
      name: Map.get(voter, "name"),
      registration_number: Map.get(voter, "registration_number"),
      role: Map.get(voter, "role"),
      admission_date: parse_date(Map.get(voter, "admission_date")),
      inserted_at: now,
      updated_at: now,
      election_id: election_id
    }
  end

  defp parse_date(value) do
    case Timex.parse(value, "{D}/{0M}/{YYYY}") do
      {:ok, date} -> Timex.to_date(date)
      {:error, _} -> ""
    end
  end

  defp validate_entries(entries) do
    {valid, invalid} =
      Enum.split_with(entries, fn entry ->
        %Voter{}
        |> cast(entry, [:name, :registration_number, :role, :admission_date])
        |> validate_required([:name, :registration_number, :role, :admission_date])
        |> Map.get(:valid?)
      end)

    %{valid: valid, invalid: invalid}
  end

  defp find_voters(%{valid: entries, invalid: invalid}) do
    {insertable, already_exist} =
      Enum.split_with(entries, fn entry ->
        Voter
        |> Repo.get_by(%{
          election_id: entry.election_id,
          registration_number: entry.registration_number
        })
        |> is_nil()
      end)

    %{valid: insertable, invalid: invalid, already_exist: already_exist}
  end

  defp insert_entries(%{valid: entries, invalid: invalid, already_exist: already_exist}) do
    Repo.insert_all(Voter, entries)
    %{inserted: entries, invalid: invalid, already_exist: already_exist}
  end
end
