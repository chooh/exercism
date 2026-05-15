defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    factors
    |> Enum.map(&f(limit, &1))
    |> List.flatten
    |> Enum.uniq
    |> Enum.sum
  end

  @spec f(non_neg_integer(), non_neg_integer()) :: [non_neg_integer()]
  defp f(_limit, 0), do: []
  defp f(limit, factor) do
    Stream.unfold(factor, fn
      acc when limit > acc -> {acc, acc + factor}
      _ -> nil
    end) |> Enum.to_list
  end
end
