defmodule Voting.Repo.Migrations.CreateVoters do
  use Ecto.Migration

  def change do
    create table(:voters) do
      add :name, :string, null: false
      add :admission_date, :date, null: false
      add :registration_number, :string, null: false
      add :role, :string, null: false
      add :voted, :boolean, default: false, null: false
      add :election_id, references(:elections, on_delete: :nothing)

      timestamps()
    end

    create index(:voters, [:election_id])
    create unique_index(:voters, [:election_id, :registration_number])
  end
end
