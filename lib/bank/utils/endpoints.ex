defmodule Bank.Utils.Endpoints do

  alias Bank.Storage.Users
  alias Bank.Storage.Acounts
  alias Bank.Utils.Generator


  def balances(port, jsonBody) do
    post('http://localhost:#{port}/balances', jsonBody)
  end
  
  def deposit(port, mapBody) do
    jsonBody = build_deposit_json_body(mapBody)
    post('http://localhost:#{port}/deposit', jsonBody)
  end
  
  def withdraw(port, mapBody) do
    jsonBody = build_withdraw_json_body(mapBody)
    post('http://localhost:#{port}/transactions', jsonBody)
  end

  def transactions(port, jsonBody) do
    post('http://localhost:#{port}/withdraw', jsonBody)
  end

  def signup(port, auth_header, jsonBody) do
    post('http://localhost:#{port}/signup', auth_header, jsonBody)
  end

  def auth(port, auth_header, jsonBody) do
    post('http://localhost:#{port}/auth', auth_header, jsonBody)
  end

  defp post(endPoint, jsonBody) do
    :httpc.request(:post, {endPoint, [],'application/json', jsonBody},[], [])
  end

  defp post(endPoint, auth_header, jsonBody) do
    :httpc.request(:post, {endPoint, auth_header,'application/json', jsonBody},[], [])
  end

  def build_json_body( %{"acount" => acount}) do
     ~s<{"acount": #{acount}}> |> to_charlist
  end
    
  def build_deposit_json_body( %{"acount" => acount, "amount" => amount ,"user" => user}) do
     ~s<{"transaction": "deposit", "acount": #{acount}, "amount": #{amount}, "user": \"#{user}\"}> |> to_charlist
  end

  def build_withdraw_json_body( %{"acount" => acount, "amount" => amount,"user" => user}) do
    ~s<{"transaction": "withdraw", "acount": #{acount}, "amount": #{amount}, "user": #{user}}> |> to_charlist
  end
end
