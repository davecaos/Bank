defmodule Bank.API.Actions.Balance do
  alias Bank.Storage.DB, as: DB

  @presition 3

  def execute(acount) do
    case DB.balance(acount) do
      {:ok, new_amount} ->
        current_funds = Float.to_string(new_amount/1, decimals: @presition)
        {:ok, %{current_funds: current_funds}}

      _ ->
        {:error, %{reason: "canceled"}}
      end
  end

end

