defmodule Bank.API.Handlers.Transactions do
  use Raxx.SimpleServer
  alias Bank.API
  alias Bank.API.Actions.Deposit, as: Deposit
  alias Bank.API.Actions.Withdraw, as: Withdraw
  alias Bank.Utils.Option , as: Option

  @deposit "deposit"
  @withdraw "withdraw"

  @impl Raxx.SimpleServer


  def handle_request(request = %{method: :POST}, _state) do
    IO.puts("#{inspect(request.body)}")
    case Jason.decode(request.body) do
      {:ok, %{"transaction" => @deposit,"acount" => acount, "amount" => amount ,"user" => _user}} ->
        data = Deposit.execute(acount, amount)
        response(:ok)
        |> API.set_json_payload(Option.maybe(data))

      {:ok, %{"transaction" => @withdraw,"acount" => acount, "amount" => amount ,"user" => _user}} ->
          data = Withdraw.execute(acount, amount)
          response(:ok)
          |> API.set_json_payload(Option.maybe(data))

      {:ok, %{"transaction" => @deposit,"acount" => acount, "amount" => amount}} ->
        data = Deposit.execute(acount, amount)
        response(:ok)
        |> API.set_json_payload(Option.maybe(data))

      {:ok, %{"transaction" => @withdraw,"acount" => acount, "amount" => amount}} ->
          data = Withdraw.execute(acount, amount)
          response(:ok)
          |> API.set_json_payload(Option.maybe(data))

      {:ok, _} ->
        error = %{title: "Missing required data parameter 'transaction'"}

        response(:bad_request)
        |> API.set_json_payload(%{errors: [error]})

      {:error, _} ->
        error = %{title: "Could not decode request data"}

        response(:unsupported_media_type)
        |> API.set_json_payload(%{errors: [error]})
    end
  end

end
