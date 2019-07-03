defmodule BankBalanceIntegrationP2P.Test do
  use ExUnit.Case, async: true
  doctest Bank

  alias Bank.Storage.Users
  alias Bank.Storage.Acounts
  alias Bank.Utils.Generator

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    endPoint = 'http://localhost:#{port}/balances'
    {:ok, port: port, endPoint: endPoint}
  end

  def post(endPoint, jsonBody) do
    :httpc.request(:post, {endPoint, [],'application/json',jsonBody},[], [])
  end

  test "Do a deposit to a brand new user", %{port: port, endPoint: endPoint} do
    new_user = Generator.random()
    Users.new(new_user)

    {:acount, new_acount}  = Acounts.new()
    Users.add_acount_to(new_user, new_acount)

    jsonBody = build_json_body( %{"acount" => new_acount})
    assert {:ok, response} = :httpc.request(:post, {'http://localhost:#{port}/balances', [],'application/json',jsonBody},[], [])
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert {:ok, {:amount, 0}} == Acounts.query_funds_by(new_acount)



    jsonBody = build_json_body2( %{"acount" => new_acount, "amount" => 10 ,"user" => new_user})
    assert {:ok, response2} = :httpc.request(:post, {'http://localhost:#{port}/transactions', [],'application/json',jsonBody},[], [])
    assert {{_, 200, 'OK'}, _headers, body} = response2
    assert  body == '{"data":{"current_funds":"10.000"}}'
  end

  test "Do a withdraw to a brand new user", %{port: port, endPoint: endPoint} do
    new_user = Generator.random()
    Users.new(new_user)

    {:acount, new_acount}  = Acounts.new()
    Users.add_acount_to(new_user, new_acount)

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

end
