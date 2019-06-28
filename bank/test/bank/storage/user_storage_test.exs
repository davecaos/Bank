defmodule Bank.Storage.UsersTest do
  use ExUnit.Case
  doctest Bank

  def random do
    length = 32
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end

  alias Bank.Storage.Users
  alias Bank.Storage.Generator
  setup %{} do
    true = Users.init()
    :ok
  end

  test "Add User" do
    new_user = "Gatinho"
    assert  {{:user, new_user}, {:acounts, []}} == Users.new(new_user)
  end

  test "Add Ramdon Users" do
    newNames = for _ <- 0..10, do: random()
    Enum.each(newNames , fn(name) -> assert {{:user, name}, {:acounts, []}} ==  Users.new(name) end)
    Enum.each(newNames , fn(name) -> assert {:error, :already_exists} ==  Users.new(name) end)
  end


end
