defmodule Bank.API.Actions.Balance do
  alias Bank.API
  alias Bank.Storage.DB, as: DB

  @presition 3

  def balance(acount) do
    case DB.balance(acount) do
      {:ok, new_amount} ->
        message = Float.to_string(new_amount, decimals: @presition)
        %{message: message}

      _ ->
        %{error: "canceled"}
      end
  end

end
