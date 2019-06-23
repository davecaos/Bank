defmodule Bank.STORAGE.Users do

  def init() do

    :ets.new(:users, [:set, :public, :named_table])
  end

  def new( user) do

    new_acount = 1
    :ets.insert(:users, {{:users, user},{:acounts, acount}})

  end

  def acount( user) do

    available_money = acount( user)
    if available_money >= amount then do
      new_amount = available_money - amount

      :ets.lookup(:acounts, {user, new_amount })

      {:ok, new_amount}
    else

      {:ok, new_amount}
  end

end




end
