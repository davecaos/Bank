defmodule Bank.API.Controller.Balances do
  use Raxx.SimpleServer
  alias Bank.API
  alias Bank.API.Actions.Deposit
  alias Bank.API.Actions.Withdraw

  @deposit "deposit"
  @withdraw "withdraw"

  @impl Raxx.SimpleServer
  def handle_request(_request = %{method: :POST}, _state) do
    data = %{message: "Hello, Raxx!"}

    response(:ok)
    |> set_body(Jason.encode!(%{data: data}))
  end

  def handle_request(request = %{method: :POST}, _state) do
    case Jason.decode(request.body) do
      {:ok, %{"transaction" => @deposit,"acount" => acount, "amount" => amount}} ->
        data = Deposit.deposit(acount, amount)
        response(:ok)
        |> API.set_json_payload(%{data: data})

        {:ok, %{"transaction" => @withdraw,"acount" => acount, "amount" => amount}} ->
          data = Withdraw.withdraw(acount, amount)
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
