defmodule Voting.Repo.Migrations.CreateAdministrators do
  use Ecto.Migration

  def change do
    create table(:administrators) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end
  end
end
