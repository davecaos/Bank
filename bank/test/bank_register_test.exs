defmodule BankRegisterTest do
  use ExUnit.Case, async: true
  doctest Bank

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    {:ok, port: port}
  end

  test "Status health check", %{port: port} do
    assert {:ok, response} = :httpc.request('http://localhost:#{port}/singup')
    assert {{_, 200, 'OK'}, _headers, _body} = response
  end

  test "Wrong url", %{port: port} do
    assert {:ok, response} = :httpc.request('http://localhost:#{port}/wrong')
    assert {{_, 404, 'Not Found'}, _headers, _body} = response
  end

end
