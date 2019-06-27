defmodule Bank.API.Actions.Withdraw do
  alias Bank.API
  alias Bank.Storage.DB, as: DB

  @presition 3

  def withdraw(acount, amount) do
    case DB.withdraw(acount, amount) do
      {:ok, new_amount} ->
        message = Float.to_string(new_amount, decimals: @presition)
        %{message: message}

      _ ->
        %{error: "canceled"}
      end
  end
end
