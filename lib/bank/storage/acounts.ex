defmodule Bank.Storage.Acounts do

  # The module name represent the main entity to be pesisted and also the primary key.
  # The Acount "has" funds

  @bucket :acounts

  def init() do
    autoincrement_index = 1
    @bucket == :ets.new(@bucket, [:set, :public, :named_table])
    :ets.insert(@bucket, {:autoincrement_index, autoincrement_index})
    true
  end

  def new() do
    {:ok, acount_number} = autoincrement_index()
    new_acount = {{:acount, acount_number},{:amount, 0}}
    :ets.insert(@bucket, new_acount)
    {:acount, acount_number}
  end

  def query_funds_by(acount) do
    lookup = :ets.lookup(@bucket , {:acount, acount})
    case lookup do
      [] ->
        {:error, :not_found}

      [{{:acount, ^acount}, {:amount, amount }}] ->
        {:ok, {:amount, amount}}
    end
  end

  def withdraw( acount, amount) do
    {:ok, {:amount, available_funds}} = query_funds_by(acount)
    if available_funds >= amount  do
      new_amount = available_funds - amount
      :ets.insert(@bucket, {{:acount, acount}, {:amount, new_amount }})
      {:ok, {:amount, new_amount}}
    else
      {:error, {:not_enough_funds_for_withdraw, available_funds}}
  end
end

  def deposit( acount, amount) do
    {:ok, {:amount, available_funds}} = query_funds_by(acount)
    new_amount = available_funds + amount
    :ets.insert(@bucket, {{:acount, acount}, {:amount, new_amount }})
    {:ok, {:amount, new_amount}}
  end

  def exist?(acount) do
    {:error, :not_found} != query_funds_by(acount)
  end

  def autoincrement_index() do
    [{:autoincrement_index, current_index}] = :ets.lookup(@bucket, :autoincrement_index)
    :ets.insert(@bucket, {:autoincrement_index, current_index + 1})

    {:ok, current_index}
  end

end
