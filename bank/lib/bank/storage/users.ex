defmodule Bank.Storage.Users do
  @bucket :users

  # The module name represent the main entity to be pesisted and also the primary key.
  # An User "has" acount(s)

  def init() do
    @bucket == :ets.new(@bucket, [:set, :public, :named_table])
  end

  def new(user) do
    acounts = []
    new_user = {{:user, user},{:acounts, acounts}}
    case :ets.insert_new(@bucket, new_user) do
      true  -> new_user
      false -> {:error, :already_exists}
    end
  end

  def add_acount_to(user, new_acount) do
    acounts = query_acounts_by(user)
    updated_acounts = [new_acount | acounts]
    :ets.update_element(@bucket, user, {1, updated_acounts})
  end

  def exist?(user) do
    {:error, :not_found} != query_acounts_by(user)
  end

  def query_acounts_by(user) do
    lookup = :ets.lookup(@bucket, {:user, user})
    case lookup do
      [] ->
        {:error, :not_found}

      [{{:user, ^user},{:acounts, acounts}}] ->
        {:ok, {:acounts, acounts}}
    end
  end

end
