defmodule Bank.STORAGE.Acounts do

  @bucket :acounts

  def init() do
    :ets.new(@bucket, [:set, :public, :named_table])
  end

  def funds( acount) do
    :ets.lookup(:acounts, {:acount, acount})
  end

  def withdraw( acount, amount) do

    available_funds = funds( acount)
    if available_funds >= amount  do
      new_amount = available_funds - amount

      :ets.insert(@bucket, {{:acount, acount}, {:amount, new_amount }})

      {:ok, new_amount}
    else

      {:error, {:no_enough_funds_for_withdraw, available_funds}}
  end
end

  def deposit( acount, amount) do

    available_funds = funds( acount)
    new_amount = available_funds + amount
    :ets.insert(@bucket, {{:acount, acount}, {:amount, new_amount }})
    {:ok, new_amount}

  end

end
