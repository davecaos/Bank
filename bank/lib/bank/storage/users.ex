defmodule Bank.STORAGE.Users do

  @bucket :users
  alias Bank.STORAGE.Acounts

  def init() do
    :ets.new(@bucket, [:set, :public, :named_table])
    autoincrement_index = 0
    :ets.insert(:users, {:autoincrement_index, autoincrement_index})
  end

  def new(user) do

    new_acount = Acounts.new()
    new_user = {{:users, user},{:acount, new_acount}}
    :ets.insert(@bucket, new_user)
    new_user
  end

  def query_acount_by(user) do

    lookup = :ets.lookup(@bucket, user)
    case lookup do
      [] ->
        {:error, :not_found}

      [{{:users, user},{:acount, acount}}] ->
        {:ok, {:acount, acount}}
    end



  end


end
