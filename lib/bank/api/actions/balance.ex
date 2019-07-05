defmodule Bank.API.Actions.Balance do
  alias Bank.Storage.DB, as: DB

  @presition 3

  def execute(acount) do
    try do
      case DB.balance(acount) do
        {:ok, {:amount, amount}} ->
          current_funds = Float.to_string(amount/1, decimals: @presition)
          {:ok, %{current_funds: current_funds}}

        _ ->
          {:error, %{reason: "Canceled Operation"}}
        end
    rescue
      _error in RuntimeError -> {:error, %{reason: "Internal error"}}
    end
  end
end

