defmodule Bank.STORAGE.Acounts do

  @bucket :acounts

  def init() do
    :ets.new(@bucket, [:set, :public, :named_table])
  end

  def new() do

    {:ok, acount_number} = autoincrement_index()
    new_acount = {{:acount, acount_number},{:amount, 0}}
    :ets.insert(@bucket,new_acount)
    {:acount, acount_number}
  end

  def query_funds_by(acount) do
    lookup = :ets.lookup(@bucket , {:acount, acount})
    case lookup do
      [] ->
        {:error, :not_found}

      [{{:acount, acount}, {:amount, amount }}] ->
        {:ok, {:amount, amount}}
    end

  end

  def withdraw( acount, amount) do
    {:ok, {:amount, available_funds}} = query_funds_by(acount)
    if available_funds >= amount  do
      new_amount = available_funds - amount
      :ets.insert(@bucket, {{:acount, acount}, {:amount, new_amount }})
      {:ok, new_amount}
    else
      {:error, {:no_enough_funds_for_withdraw, available_funds}}
  end
end

  def deposit( acount, amount) do
    {:ok, available_funds} = query_funds_by(acount)
    new_amount = available_funds + amount
    :ets.insert(@bucket, {{:acount, acount}, {:amount, new_amount }})
    {:ok, new_amount}

  end

  def autoincrement_index() do
    [{:autoincrement_index, current_index}] = :ets.lookup(@bucket, :autoincrement_index)
    :ets.insert(@bucket, {:autoincrement_index, current_index + 1})

    {:ok, current_index}
  end

end
