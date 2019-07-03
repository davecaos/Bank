defmodule Bank.API.Handlers.Signup do
  use Raxx.SimpleServer
  import Raxx.BasicAuthentication

  alias Bank.API
  alias Bank.Storage.DB, as: DB

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    case fetch_basic_authentication(request) do
      {:ok, {user, password}} ->
        DB.signup(user, password)
        signer = Joken.Signer.parse_config(:rsa_signer)
        token = Joken.generate_and_sign!(%{}, %{"user" => user}, signer)
        data = %{token: token}

        response(:ok)
        |> API.set_json_payload(%{data: data})

      {:error, _} ->
        error = %{title: "Malformed Request"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})
    end
  end
end
