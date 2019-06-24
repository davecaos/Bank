defmodule Bank.API.Actions.Users do
  use Raxx.SimpleServer
  alias Bank.API

  @impl Raxx.SimpleServer
  def handle_request(_request = %{method: :GET}, _state) do
    data = %{message: "Hello, Raxx!"}

    response(:ok)
    |> set_body(Jason.encode!(%{data: data}))
  end

  def handle_request(request = %{method: :POST}, _state) do
    case Jason.decode(request.body) do
      {:ok, %{"name" => name}} ->
        message = Bank.welcome_message(name)
        data = %{message: message}

        response(:ok)
        |> API.set_json_payload(%{data: data})

      {:ok, _} ->
        error = %{title: "Missing required data parameter 'name'"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})

      {:error, _} ->
        error = %{title: "Could not decode request data"}

        response(:unsupported_media_type)
        |> API.set_json_payload(%{errors: [error]})
    end
  end
end
