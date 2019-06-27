defmodule Bank.API.Actions.Status do
  use Raxx.SimpleServer
  alias Bank.API

  @impl Raxx.SimpleServer
  def handle_request(_request = %{method: :GET}, _state) do
    data = %{message: "Bank Server UP!"}

    response(:ok)
    |> set_body(Jason.encode!(%{data: data}))
  end
end
