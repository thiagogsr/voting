defmodule Voting.DatesOverlapTest do
  use Voting.DataCase, async: true

  import Voting.Factory

  alias Voting.DatesOverlap

  describe "validate_dates_overlap/3" do
    test "returns a valid changeset when dates don't overlap" do
      changeset =
        :election
        |> build()
        |> Ecto.Changeset.change(%{
          starts_at: ~U[2020-02-01 11:00:00Z],
          ends_at: ~U[2020-02-29 20:59:59Z]
        })

      assert %Ecto.Changeset{valid?: true, errors: []} =
               DatesOverlap.validate_dates_overlap(changeset, :starts_at, :ends_at)
    end

    test "returns an invalid changeset when dates overlap" do
      changeset =
        :election
        |> build()
        |> Ecto.Changeset.change(%{
          starts_at: ~U[2020-02-29 20:59:59Z],
          ends_at: ~U[2020-02-01 11:00:00Z]
        })

      assert %Ecto.Changeset{valid?: false} =
               changeset = DatesOverlap.validate_dates_overlap(changeset, :starts_at, :ends_at)

      assert %{starts_at: ["should be before ends_at"]} = errors_on(changeset)
    end

    test "returns an invalid changeset when changeset is already invalid" do
      changeset =
        :election
        |> build()
        |> Ecto.Changeset.change(%{name: ""})
        |> Ecto.Changeset.validate_required([:name])

      assert %Ecto.Changeset{valid?: false} =
               DatesOverlap.validate_dates_overlap(changeset, :starts_at, :ends_at)
    end
  end
end
