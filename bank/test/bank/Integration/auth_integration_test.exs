defmodule BankAuthIntegration.Test do
  use ExUnit.Case, async: true
  doctest Bank
  alias Bank.Utils.Generator
  alias Bank.Utils.Endpoints, as: Endpoints

  @times 10

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Bank.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)
    {:ok, port: port}
  end

  test "Joken JWT generation with /signup & /auth", %{port: port} do
    newUsers =  for _ <- 0..@times , do: Generator.random
    Enum.each(newUsers, fn newUser->  newUser |> check_joken_jwt_generation_with_signup(port) end)
    Enum.each(newUsers, fn newUser->  newUser |>  check_joken_jwt_generation_with_auth(port) end)
  end


  defp check_joken_jwt_generation_with_signup(user, port) do
    postToSignup = &Endpoints.signup/3
    check_joken_jwt_generation(user, postToSignup, port)
  end

  defp check_joken_jwt_generation_with_auth(user, port) do
    postToAuth = &Endpoints.auth/3
    check_joken_jwt_generation(user, postToAuth, port)
  end

  defp check_joken_jwt_generation(user, postCallBack, port) do
    password = String.reverse(user)
    {:ok, authorization} = BasicAuthentication.encode_authentication(user, password)
    auth_header = [{'authorization', authorization |> to_charlist }]
    jsonBody = []

    assert {:ok, response} = postCallBack.(port, auth_header, jsonBody)
    assert {{_, 200, 'OK'}, _headers, body} = response
    assert {:ok, %{"data" => %{ "token" => token}}} = Jason.decode( body)
    signer = Joken.Signer.parse_config(:rsa_signer)
    assert {:ok, %{"user" => ^user}} = Joken.verify_and_validate(%{}, token, signer)
  end
end
