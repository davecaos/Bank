defmodule BankAuthIntegration.Test do
  use ExUnit.Case, async: true
  doctest Bank
  alias Bank.Utils.Generator

  @times 10

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    {:ok, port: port}
  end

  test "Joken JWT generation", %{port: port} do
    newUsers =  for _ <- 0..@times , do: Generator.random
    Enum.each(newUsers, fn newUser->  newUser |> pre_signup_users(port) end)
    Enum.each(newUsers, fn newUser->  newUser |>  check_joken_jwt_generation_with_auth(port) end)
  end

  defp pre_signup_users(user, port) do
    endPoint = 'http://localhost:#{port}/signup'
    check_joken_jwt_generation(user, endPoint, port)
  end

  defp check_joken_jwt_generation_with_auth(user, port) do
    endPoint = 'http://localhost:#{port}/auth'
    check_joken_jwt_generation(user, endPoint, port)
  end

  defp check_joken_jwt_generation(user, endPoint, port) do
    password = String.reverse(user)
    {:ok, authorization} = BasicAuthentication.encode_authentication(user, password)
    auth_header = [{'authorization', authorization |> to_charlist }]
    jsonBody = []
    request = {endPoint, auth_header, 'application/json', jsonBody}

    assert {:ok, response} = :httpc.request(:post, request, [], [])
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert {:ok, %{"data" => %{ "token" => token}}} = Jason.decode( body)
    signer = Joken.Signer.parse_config(:rsa_signer)

    assert {:ok, %{"user" => ^user}} = Joken.verify_and_validate(%{}, token, signer)
  end
end
