defmodule Bank.Storage.AcountsTest do
  use ExUnit.Case
  doctest Bank

  alias Bank.Storage.Acounts, as: Acounts
  setup %{} do
    true = Acounts.init()
    :ok
  end

  test "Add one Acount" do
    assert  {:acount, 1} == Acounts.new()
  end

  test "Incremetal Acount asigment" do
    assert {:acount, first} = Acounts.new()
    assert {:acount, second} = Acounts.new()
    assert second == (first + 1)
    assert {:acount, third} = Acounts.new()
    assert third == (second + 1)
  end

end
