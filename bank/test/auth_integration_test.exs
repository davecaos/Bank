defmodule BankAuthIntegrationTest do
  use ExUnit.Case, async: true
  doctest Bank
  alias Bank.Utils.Generator

  @times 100

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    {:ok, port: port}
  end

  test "Basic Auth to Joken JWT generation", %{port: port} do
    Enum.each 0..@times, fn _ ->  Generator.random |> check_joken_jwt_generation(port) end
  end

  defp check_joken_jwt_generation(user, port) do
    {:ok, authorization} = BasicAuthentication.encode_authentication(user, "open sesame")
    auth_header = [{'authorization', authorization |> to_charlist }]
    jsonBody = []
    request = {'http://localhost:#{port}/signup', auth_header, 'application/json', jsonBody}

    assert {:ok, response} = :httpc.request(:post, request, [], [])
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert {:ok, %{"data" => %{ "token" => token}}} = Jason.decode( body)
    signer = Joken.Signer.parse_config(:rsa_signer)

    assert {:ok, %{"user" => ^user}} = Joken.verify_and_validate(%{}, token, signer)
  end
end
