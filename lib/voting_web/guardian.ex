defmodule VotingWeb.Guardian do
  @moduledoc """
  JWT Authentication
  """
  use Guardian, otp_app: :voting

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Voting.AdminRepo.get_admin!(id)
    {:ok, resource}
  end
end
