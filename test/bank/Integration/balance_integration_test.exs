defmodule BankBalanceIntegration.Test do
  use ExUnit.Case, async: true
  doctest Bank

  alias Bank.Storage.Users
  alias Bank.Storage.Acounts
  alias Bank.Utils.Generator
  alias Bank.Utils.Endpoints, as: Endpoints

  @times 10

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    {:ok, port: port}
  end

  def post(endPoint, jsonBody) do
    :httpc.request(:post, {endPoint, [],'application/json',jsonBody},[], [])
  end

  test "Balance meanwhile do a deposit to a brand new user", %{port: port} do
    for _ <- 0..@times , do: check_balance_in_deposit(port)
  end

  def check_balance_in_deposit(port) do
    new_user = Generator.random()
    Users.new(new_user)

    {:acount, new_acount}  = Acounts.new()
    Users.add_acount_to(new_user, new_acount)

    jsonBody = build_json_body( %{"acount" => new_acount})
    assert {:ok, response} = Endpoints.balances(port, jsonBody)
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert {:ok, {:amount, 0}} == Acounts.query_funds_by(new_acount)



    jsonBody = build_json_body2( %{"acount" => new_acount, "amount" => 10 ,"user" => new_user})
    assert {:ok, response} = :httpc.request(:post, {'http://localhost:#{port}/transactions', [],'application/json',jsonBody},[], [])
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert  body == '{"data":{"current_funds":"10.000"}}'
  end

  test "Balance meanwhile do a withdraw to a brand new user", %{port: port} do
    for _ <- 0..@times , do: check_balance_in_withdraw(port)
  end

  def check_balance_in_withdraw(port) do
    new_user = Generator.random()
    Users.new(new_user)

    {:acount, new_acount}  = Acounts.new()
    Users.add_acount_to(new_user, new_acount)

    jsonBody = build_json_body( %{"acount" => new_acount})
    assert {:ok, response} = Endpoints.balances(port, jsonBody)
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert {:ok, {:amount, 0}} == Acounts.query_funds_by(new_acount)

    jsonBody = build_json_body2( %{"acount" => new_acount, "amount" => 10 ,"user" => new_user})
    assert {:ok, response} = :httpc.request(:post, {'http://localhost:#{port}/transactions', [],'application/json',jsonBody},[], [])
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert  body == '{"data":{"current_funds":"10.000"}}'
  end

  def build_json_body( %{"acount" => acount}) do
     ~s<{"acount": #{acount}}> |> to_charlist
  end

  def build_json_body2( %{"acount" => acount, "amount" => amount,"user" => user}) do
    ~s<{"transaction": "deposit", "acount": #{acount}, "amount": #{amount}, "user": \"#{user}\"  }>  |> to_charlist
  end

  def current_funds_body( %{"current_funds" => current_funds}) do
    ~s<{"data":{"current_funds": #{current_funds}}>  |> to_charlist
  end

end
