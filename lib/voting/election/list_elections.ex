defmodule Voting.ListElections do
  @moduledoc """
  Listing elections
  """

  import Ecto.Query, only: [from: 2]

  alias Voting.{Election, Repo}

  def run do
    query = from(e in Election, order_by: e.name)
    Repo.all(query)
  end
end
