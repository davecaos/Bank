defmodule Bank.Storage.Acounts.UnitTest do
  use ExUnit.Case
  doctest Bank

  alias Bank.Storage.Acounts, as: Acounts
  setup %{} do
    :ok
  end

  test "Add one Acount" do
     {:acount, newAcount} = Acounts.new()
     assert is_integer(newAcount) && newAcount > 0
  end

  test "Incremetal Acount asigment" do
    assert {:acount, first} = Acounts.new()
    assert {:acount, second} = Acounts.new()
    assert second == (first + 1)
    assert {:acount, third} = Acounts.new()
    assert third == (second + 1)
  end

  test "Deposit action and Query funds by acount" do
    newAcounts =
      for _ <- 0..10 do
        {:acount, acount} = Acounts.new()
        acount
      end
    Enum.each(newAcounts , fn(acount) -> assert {:ok, {:amount, 0}} == Acounts.query_funds_by(acount) end)

    Enum.each(newAcounts , fn(acount) -> Acounts.deposit( acount, acount * acount) end)
    Enum.each(newAcounts , fn(acount) -> assert {:ok, {:amount, acount * acount}} == Acounts.query_funds_by(acount) end)
  end

  test "Query exist? acount check" do
    {:acount, existAcount} = Acounts.new()
    assert true == Acounts.exist?(existAcount)

    nonExistAcount = existAcount + 1000000
    assert false == Acounts.exist?(nonExistAcount)
  end

  test "Withdraw action and Query funds by acount" do
    newAcounts =
      for _ <- 0..10 do
        {:acount, acount} = Acounts.new()
        acount
      end
    Enum.each(newAcounts , fn(acount) -> assert {:ok, {:amount, 0}} == Acounts.query_funds_by(acount) end)

    Enum.each(newAcounts , fn(acount) -> Acounts.deposit( acount, acount * acount) end)
    Enum.each(newAcounts , fn(acount) -> assert {:ok, {:amount, acount * acount}} == Acounts.query_funds_by(acount) end)

    Enum.each(newAcounts , fn(acount) -> Acounts.withdraw(acount, acount * acount) end)

    Enum.each(newAcounts , fn(acount) -> assert {:ok, {:amount, 0}} == Acounts.query_funds_by(acount) end)
  end


end
