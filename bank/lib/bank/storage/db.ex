defmodule Bank.Storage.DB do
  use Agent

  alias Bank.Storage.Acounts
  alias Bank.Storage.Users

  def start_link(initial_value) do
    Agent.start_link(fn -> init() end, name: __MODULE__)
  end

  def new_user(user) do
    critical_section(fn -> Users.new(user) end)
  end

  def user_exist?(user) do
    critical_section(fn -> Users.exist?(user) end)
  end

  def add_acount_to(user) do
    critical_section(fn -> Users.add_acount_to(user, Acounts.new()) end)
  end

  def acount_exist?(acount) do
    critical_section(fn -> Acounts.exist?(acount) end)
  end

  def query_acounts_by(user) do
    critical_section(fn -> Users.query_acounts_by(user) end)
  end

  def withdraw(acount, amount) do
    critical_section(fn -> Acounts.withdraw( acount, amount) end)
  end

  def deposit(acount, amount) do
    critical_section(fn ->  Acounts.deposit(acount, amount) end)
  end

  def balance(acount) do
    critical_section(fn ->  Acounts.query_funds_by(acount) end)
  end


  defp critical_section(lambda) do
    Agent.get(__MODULE__, lambda)
  end

  def init() do
    Users.init()
    Acounts.init()
  end
end
