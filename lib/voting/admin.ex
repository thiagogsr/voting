defmodule Voting.Admin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "administrators" do
    field :email, :string
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(admin, attrs) do
    admin
    |> cast(attrs, [:name, :email, :password_hash])
    |> validate_required([:name, :email, :password_hash])
  end
end
