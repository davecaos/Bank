defmodule Bank.Utils.Generator do
  def random do
    length = 64
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end

end
