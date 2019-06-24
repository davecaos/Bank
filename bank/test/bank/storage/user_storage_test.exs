defmodule Bank.STORAGE.UsersTest do
  use ExUnit.Case
  doctest Bank

  alias Bank.STORAGE.Users
  setup %{} do
    true = Users.init()
    :ok
  end

  test "Add User" do
    new_user = "Gatinho"
    assert  {{:users, new_user}, {:acount, _}} = Users.new(new_user)

  end
end
