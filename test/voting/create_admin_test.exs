defmodule Voting.CreateAdminTest do
  use Voting.DataCase, async: true

  alias Voting.{Admin, CreateAdmin}

  describe "run/1" do
    test "returns a struct when the params are valid" do
      params = %{name: "Foo", email: "foo@bar.com", password: "123456"}
      assert {:ok, %Admin{} = admin} = CreateAdmin.run(params)
      assert admin.name == "Foo"
      assert admin.email == "foo@bar.com"
      assert admin.password_hash != "123456"
    end

    test "returns error when name is missing" do
      params = %{name: "", email: "foo@bar.com", password: "123456"}
      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when email is missing" do
      params = %{name: "Foo", email: "", password: "123456"}
      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error when password is missing" do
      params = %{name: "Foo", email: "foo@bar.com", password: ""}
      assert {:error, %Ecto.Changeset{} = changeset} = CreateAdmin.run(params)
      %{password: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
