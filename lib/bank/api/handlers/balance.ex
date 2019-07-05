defmodule Bank.API.Handlers.Balances do
  use Raxx.SimpleServer
  alias Bank.API
  alias Bank.API.Actions.Balance
  alias Bank.Utils.Option , as: Option

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    case Jason.decode(request.body) do
      {:ok, %{ "acount" => acount}} ->
        data = Balance.execute(acount)
        response(:ok)
        |> API.set_json_payload(Option.maybe(data))

      {:ok, _} ->
        error = %{title: "Missing required data parameter 'acount'"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})

      {:error, _} ->
        error = %{title: "Could not decode request data"}
        response(:unsupported_media_type)
        |> API.set_json_payload(%{errors: [error]})
    end
  end
end

