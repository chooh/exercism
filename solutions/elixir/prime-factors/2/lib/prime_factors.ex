defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: factors_for(number, [])

  defp factors_for(1, acc), do: Enum.reverse(acc)
  defp factors_for(number, acc) do
    factor = Enum.find(2..number, fn x -> rem(number, x) == 0 end)
    factors_for(div(number, factor), [factor|acc])
  end
end
