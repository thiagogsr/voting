defmodule Voting.Election do
  @moduledoc """
  Election schema
  """
  use Ecto.Schema

  alias Voting.Admin

  schema "elections" do
    field :cover, :string
    field :ends_at, :utc_datetime
    field :name, :string
    field :notice, :string
    field :starts_at, :utc_datetime
    belongs_to :created_by, Admin

    timestamps()
  end
end
