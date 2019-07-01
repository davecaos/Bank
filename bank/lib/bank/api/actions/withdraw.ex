defmodule Bank.API.Actions.Withdraw do
  alias Bank.Storage.DB, as: DB

  @presition 3

  def execute(acount, amount) do
    case DB.withdraw(acount, amount) do
      {:ok, new_amount} ->
        current_funds = Float.to_string(new_amount, decimals: @presition)
        {:ok, %{current_funds: current_funds}}

      _ ->
        {:error, %{reason: "canceled"}}
      end
  end
end
