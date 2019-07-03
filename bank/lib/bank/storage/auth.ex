defmodule Bank.Storage.Auth do
  @bucket :auth

  # The module name represent the main entity to be pesisted and also the primary key.
  # An User "has" only one auth token

  def init() do
    :ets.new(@bucket, [:set, :public, :named_table])
  end

  def new(user, password) do
    login = {{:users, user}, {:password, password}}
    :ets.insert(@bucket, login)
  end


  def match_registration(user, password) do
    lookup = :ets.lookup(@bucket, {:users, user})
    case lookup do
      [] ->
        false

      [{{:users, ^user}, {:password, ^password}}] ->
        true
    end
  end

end
