defmodule Bank.Storage.Generator do
  use EntropyString, charset: charset64
  @bits entropy_bits(1.0e6, 1.0e12)
  def random do
    length = 32
    for _n <- 1..4, do:  :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end

end
