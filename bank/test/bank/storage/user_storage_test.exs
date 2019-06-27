defmodule Bank.Storage.UsersTest do
  use ExUnit.Case
  doctest Bank

  alias Bank.Storage.Users
  setup %{} do
    true = Users.init()
    :ok
  end

  test "Add User" do
    new_user = "Gatinho"
    assert  {{:user, new_user}, {:acounts, []}} == Users.new(new_user)
  end
end
