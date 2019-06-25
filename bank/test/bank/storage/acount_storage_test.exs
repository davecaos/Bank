defmodule Bank.STORAGE.AcountsTest do
  use ExUnit.Case
  doctest Bank

  alias Bank.STORAGE.Acounts
  setup %{} do
    true = Acounts.init()
    :ok
  end

  test "Add Acount" do
    new_user = "Gatinho"
    assert  {{:users, new_user}, {:acount, _}} = Acounts.new()

  end
end
