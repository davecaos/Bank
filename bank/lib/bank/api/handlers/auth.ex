defmodule Bank.API.Handlers.Auth do
  use Raxx.SimpleServer
  alias Bank.API
  import Raxx.BasicAuthentication

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :GET}, _state) do
         caca = fetch_basic_authentication(request)
       IO.puts("my fetch_basic_authentication() is: #{inspect(caca)}")

    case fetch_basic_authentication(request) do
      {:ok, {user, password}} ->
        data = %{error: "Wrong data encoding"}
        case DB.match_registration(user, password) do
          true ->
            token = token(user)
            data = %{token: token}
          false ->
            data = %{error: "Wrong user or password input"}
        end

        response(:ok)
        |> API.set_json_payload(data)

      {:error, _} ->
        error = %{title: "Malformed Request"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})

    end
  end

  def token(user) do
    signer = Joken.Signer.parse_config(:myrsasigner)
    token = Joken.generate_and_sign!(%{}, %{"user" => user}, signer)
    token
  end
end
