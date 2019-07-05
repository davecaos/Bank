defmodule Bank.API.Handlers.Signup do
  use Raxx.SimpleServer
  import Raxx.BasicAuthentication

  alias Bank.API
  alias Bank.Utils.Option , as: Option
  alias Bank.API.Actions.Signup, as: Signup


  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    case fetch_basic_authentication(request) do
      {:ok, {user, password}} ->
        data = Signup.execute(user, password)
        response(:ok)
        |> API.set_json_payload(Option.maybe(data))

      {:error, _} ->
        error = %{title: "Malformed Request"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})
    end
  end
end
