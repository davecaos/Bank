defmodule Bank.STORAGE.Users do

  @bucket :users

  def init() do
    :ets.new(@bucket, [:set, :public, :named_table])
    autoincrement_index = 0
    :ets.insert(:users, {:autoincrement_index, autoincrement_index})
  end

  def new(user) do

    new_acount = autoicrement_index()
    new_user = {{:users, user},{:acount, new_acount}}
    :ets.insert(@bucket, new_user)
    new_user
  end

  def acount(user) do

    lookup = :ets.lookup(@bucket, user)
    case lookup do
      [] ->
        {:error, :user_not_found}

      [{{:users, user},{:acount, acount}}] ->
        {:ok, {:acount, acount}}
    end



end

def autoincrement_index() do
  [{:autoincrement_index, current_index}] = :ets.lookup(@bucket, :autoincrement_index)
  :ets.insert(@bucket, {:autoincrement_index, current_index + 1})

  current_index
end


end
