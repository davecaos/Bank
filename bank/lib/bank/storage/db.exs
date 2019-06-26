defmodule Bank.STORAGE.DB do
  use Agent

  alias Bank.STORAGE.Acounts
  alias Bank.STORAGE.Users

  def start_link(initial_value) do
    Agent.start_link(fn -> init() end, name: __MODULE__)
  end

  def new_user(user) do
    Agent.get(__MODULE__, fn -> Users.new(user) end)
  end

  def user_exist?(user) do
    Agent.get(__MODULE__, fn -> Users.exist?(user) end)
  end

  def add_acount_to(user) do
    Agent.get(__MODULE__, fn -> Users.add_acount_to(user, Acounts.new()) end)
  end

  def acount_exist?(acount) do
    Agent.get(__MODULE__, fn -> Acount.exist?(acount) end)
  end

  def query_acounts_by(user) do
    Agent.get(__MODULE__, fn -> Users.query_acounts_by(user) end)
  end

  def query_funds_by(acount) do
    Agent.get(__MODULE__, fn -> Acount.query_funds_by(acount) end)
  end

  def withdraw(acount, amount) do
    Agent.get(__MODULE__, fn -> Acount.withdraw( acount, amount) end)
  end

  def deposit(acount, amount) do
    Agent.get(__MODULE__, fn ->  Acount.deposit(acount, amount) end)
  end


  def init() do
    Users.init()
    Acounts.init()
  end
end
