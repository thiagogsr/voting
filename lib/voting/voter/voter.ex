defmodule Voting.Voter do
  @moduledoc """
  Voter schema
  """

  use Ecto.Schema

  alias Voting.Election

  schema "voters" do
    field :admission_date, :date
    field :name, :string
    field :registration_number, :string
    field :role, :string
    field :voted, :boolean, default: false
    belongs_to :election, Election

    timestamps()
  end
end
