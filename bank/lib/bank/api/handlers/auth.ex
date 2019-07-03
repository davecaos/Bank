defmodule Bank.API.Handlers.Auth do
  use Raxx.SimpleServer
  alias Bank.API
  alias Bank.API.Actions.Auth
  alias Bank.Utils.Option , as: Option

  import Raxx.BasicAuthentication

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    case fetch_basic_authentication(request) do
      {:ok, {user, password}} ->
        data = Auth.create_token(user, password)
        response(:ok)
        |> API.set_json_payload(Option.maybe(data))

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
