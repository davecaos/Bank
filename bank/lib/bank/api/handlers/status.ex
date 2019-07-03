defmodule Bank.API.Handlers.Status do
  use Raxx.SimpleServer

  @impl Raxx.SimpleServer
  def handle_request(_request = %{method: :GET}, _state) do
    data = %{message: "Bank Server UP!"}
    response(:ok)
    |> set_body(Jason.encode!(%{data: data}))
  end
end
