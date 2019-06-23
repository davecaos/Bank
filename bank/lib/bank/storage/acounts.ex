defmodule Bank.STORAGE.Acounts do

  def init() do
    :ets.new(:acounts, [:set, :public, :named_table])
  end

  def acount( user) do
    :ets.insert(:acounts, {user, })
  end

  def withdraw( user, amount) do

    available_money = acount( user)
    if available_money >= amount then do
      new_amount = available_money - amount

      :ets.insert(:acounts, {user, new_amount })

      {:ok, new_amount}
    else

      {:ok, new_amount}
  end
end

  def deposit( user, amount) do

    available_money = acount( user)
    if available_money >= amount  do
      new_amount = available_money + amount

      :ets.insert(:acounts, {user, new_amount })

      {:ok, new_amount}
    else

      {:ok, new_amount}
    end

  end

end
