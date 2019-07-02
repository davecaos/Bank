defmodule Bank.Storage.DB do
  use Agent

  alias Bank.Storage.Acounts
  alias Bank.Storage.Users
  alias Bank.Storage.Auth

  # Elixir doesn't have primitives like locks or mutexs as synchronization mechanism by desing,
  # Due to we have to handle that with a more higher abstraction.
  #
  # Processes in Elixir is single threaded, I will use an Agent.
  # https://elixir-lang.org/getting-started/mix-otp/agent.html#the-trouble-with-state
  # Every request will be served one per time, and rest will be enqueue on the Agent's process queue
  # with this we create a Critical section and we emulate the ACI of ACID (Atomicity, Consistency, Isolation, Durability)
  # that are necessary properties of a transacional database.
  #
  # They way that a process behavies in Elixir is similar to Active Object pattern
  # https://en.wikipedia.org/wiki/Active_object


  def start_link(initial_value) do
    init()
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def new_user(user) do
    critical_section(fn _ -> Users.new(user) end)
  end

  def user_exist?(user) do
    critical_section(fn _ -> Users.exist?(user) end)
  end

  def add_acount_to(user) do
    critical_section(fn _ -> Users.add_acount_to(user, Acounts.new()) end)
  end

  def acount_exist?(acount) do
    critical_section(fn _ -> Acounts.exist?(acount) end)
  end

  def query_acounts_by(user) do
    critical_section(fn _ -> Users.query_acounts_by(user) end)
  end

  def withdraw(acount, amount) do
    critical_section(fn _ -> Acounts.withdraw( acount, amount) end)
  end

  def deposit(acount, amount) do
    critical_section(fn _ ->  Acounts.deposit(acount, amount) end)
  end

  def balance(acount) do
    critical_section(fn _ ->  Acounts.query_funds_by(acount) end)
  end

  def signup(user, password) do
    critical_section(fn _ ->  Auth.new(user, password) end)
  end

  defp critical_section(lambda) do
    Agent.get(__MODULE__, lambda)
  end

  def init() do
    Users.init()
    Acounts.init()
    Register.init()
  end
end
