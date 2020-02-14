defmodule Voting.Repo do
  use Ecto.Repo,
    otp_app: :voting,
    adapter: Ecto.Adapters.Postgres
end
