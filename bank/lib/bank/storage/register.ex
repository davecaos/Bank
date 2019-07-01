defmodule Bank.Storage.Register do
  @bucket :user_register

  # The module name represent the main entity to be pesisted and also the primary key.
  # An User "has" only one auth token

  def init() do
    :ets.new(@bucket, [:set, :public, :named_table])
  end

  def new(user, password) do
    :ets.delete(@bucket, user)
    token = 1
    time_to_live = 1
    login = {{:users, user}, {:password, password}, {:token, token}, {:time_to_live, time_to_live}}
    :ets.insert(@bucket, login)
  end


  def valid_token?(user, token) do
    {:error, :not_found} != query_token_by(user, token)
  end

  def valid_password?(user, token) do
    {:error, :not_found} != query_token_by(user, token)
  end

  def query_token_by(user, token) do
    lookup = :ets.lookup(@bucket, user)
    case lookup do
      [] ->
        {:error, :not_found}

      [{{:users, ^user}, _password, {:token, ^token}, {:time_to_live, _time_to_live}}] ->
        {:ok, {:token, token}}
    end
  end

    def match_registration(user, password) do
    lookup = :ets.lookup(@bucket, user)
    case lookup do
      [] ->
        {:error, :not_found}

      [{{:users, ^user}, {:password, password}, _token, {:time_to_live, _time_to_live}}] ->
        {:ok, {:password, password}}
    end
  end

end