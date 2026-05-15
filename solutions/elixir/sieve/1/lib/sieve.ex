defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []

  def primes_to(limit) do
    list = 2..limit |> Enum.map(&{&1, true})

    Enum.reduce(2..limit, list, fn number, acc ->
      if Enum.any?(acc, fn
           {^number, true} -> true
           _ -> false
         end) do
        mark(acc, number, number + number, limit)
      else
        acc
      end
    end)
    |> Enum.filter(fn {_, prime} -> prime end)
    |> Enum.map(&elem(&1, 0))
  end

  defp mark(list, _prime, number, limit) when number > limit, do: list

  defp mark(list, prime, number, limit) do
    Enum.map(list, fn
      {^number, true} -> {number, false}
      id -> id
    end)
    |> mark(prime, number + prime, limit)
  end
end
