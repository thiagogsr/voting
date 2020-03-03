defmodule VotingWeb.Admin.SessionViewTest do
  use ExUnit.Case, async: true

  alias VotingWeb.Admin.SessionView

  import Voting.Factory

  test "render/2 returns ok and the admin data" do
    admin = params_for(:admin, name: "John Smith")

    assert %{status: "ok", data: %{name: "John Smith", token: "foo"}} =
             SessionView.render("session.json", %{admin: admin, token: "foo"})
  end
end
