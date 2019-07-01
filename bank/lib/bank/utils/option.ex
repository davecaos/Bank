defmodule Bank.Utils.Option do

  def maybe({:ok, data}) do
    %{data: data}
  end

  def maybe({:error, reason}) do
    %{error: reason}
  end

end
