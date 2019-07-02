defmodule Bank.API.Handlers.Balances do
  use Raxx.SimpleServer
  alias Bank.API
  alias Bank.API.Actions.Balance
  alias Bank.Utils.Option , as: Option

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    IO.puts("request.body >>>>>#{inspect(request.body)}")
    IO.puts("request.body >>>>>#{inspect(Jason.decode(request.body))}")
    case Jason.decode(request.body) do
      {:ok, %{ "acount" => acount}} ->
        IO.puts("acount >>>>> #{inspect(acount)}")
        data = Balance.execute(acount)
        IO.puts("data >>>>> #{inspect(data)}")
        response(:ok)
        |> API.set_json_payload(Option.maybe(data))

      {:ok, _} ->
        error = %{title: "Missing required data parameter 'acount'"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})

      {:error, eeee} ->
        IO.puts("eeee>>>>>#{inspect(Jason.decode(eeee))}")
        error = %{title: "Could not decode request data"}

        response(:unsupported_media_type)
        |> API.set_json_payload(%{errors: [error]})
    end
  end
end

