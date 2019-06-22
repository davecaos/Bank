defmodule Bank.API.Actions.WelcomeMessageTest do
  use ExUnit.Case

  alias Bank.API.Actions.WelcomeMessage

  test "returns welcome message for a name" do
    request = Raxx.request(:POST, "/")
    |> Bank.API.set_json_payload(%{name: "Fiona"})

    response = WelcomeMessage.handle_request(request, %{})

    assert response.status == 200
    assert {"content-type", "application/json"} in response.headers
    assert {:ok, %{"data" => %{"message" => message}}} = Jason.decode(response.body)
    assert message == "Hello, Fiona!"
  end

  test "returns bad request for bad payload" do
    request = Raxx.request(:POST, "/")
    |> Bank.API.set_json_payload(%{})

    response = WelcomeMessage.handle_request(request, %{})

    assert response.status == 400
  end
end
