defmodule Bank.API.Handlers.Status do
  use Raxx.SimpleServer
  import Raxx.BasicAuthentication
  alias Bank.API

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :GET,  headers: headers}, _state) do

   # {"authorization", "Basic "<> authorization} = List.keyfind(headers ,"authorization",0)




     # IO.puts("my authorization is: #{inspect(authorization)}")
     # caca = fetch_basic_authentication(request)
     #  IO.puts("my fetch_basic_authentication() is: #{inspect(caca)}")
      data = %{message: "Bank Server UP!"}

    response(:ok)
    |> set_body(Jason.encode!(%{data: data}))
  end
end
