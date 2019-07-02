defmodule Bank.API.Actions.Deposit do
  alias Bank.Storage.DB, as: DB

  @presition 3

  def execute(acount, amount) do
    case DB.deposit(acount, amount) do
      {:ok, {:amount, funds}} ->
        current_funds = Float.to_string(funds/1, decimals: @presition)
        {:ok, %{current_funds: current_funds}}

      _ ->
        {:error, %{reason: "canceled"}}
      end
  end

end
