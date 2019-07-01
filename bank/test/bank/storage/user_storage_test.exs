defmodule Bank.Storage.UsersTest do
  use ExUnit.Case
  doctest Bank

  alias Bank.Storage.Users
  alias Bank.Utils.Generator

  setup %{} do
    :ok
  end

  test "new/1 function" do
    newNames = for _ <- 0..10, do: Generator.random()
    Enum.each(newNames, fn(name) -> assert false == Users.exist?(name) end)
    Enum.each(newNames, fn(name) -> assert {{:user, name}, {:acounts, []}} == Users.new(name) end)
    Enum.each(newNames, fn(name) -> assert {:error, :already_exists}       == Users.new(name) end)
  end

  test "exist?/1 function" do
    newNames = for _ <- 0..10, do: Generator.random()
    Enum.each(newNames, fn(name) -> assert false == Users.exist?(name) end)
    Enum.each(newNames, fn(name) -> assert {{:user, name}, {:acounts, []}} == Users.new(name) end)
    Enum.each(newNames, fn(name) -> assert true == Users.exist?(name) end)
  end
end
