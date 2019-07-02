defmodule BankRegisterIntegrationTest do
  use ExUnit.Case, async: true
  doctest Bank

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    {:ok, port: port}
  end

  test "Status health check", %{port: port} do
    auth_header = [{'Authorization','Basic ZFhObGNtNWhiV1U2Y0dGemMzZHZjbVE9' }]
    jsonBody = []
    request = {'http://localhost:#{port}/signup', auth_header, 'application/json', jsonBody}
    assert {:ok, response} =
      :httpc.request(:post, request, [], [])
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert body == 1
  end



end
