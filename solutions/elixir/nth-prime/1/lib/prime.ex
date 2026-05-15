defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(1), do: 2
  def nth(count) when count > 1 do
    Stream.iterate(2, &nextprime/1)
    |> Enum.at(count - 1)
  end

  defp prime?(2), do: true

  defp prime?(num) when num > 2 do
    last =
      num
      |> :math.sqrt()
      |> Float.ceil()
      |> trunc

    notprime =
      2..last
      |> Enum.any?(fn a -> rem(num, a) == 0 end)

    !notprime
  end

  defp nextprime(num) do
    cond do
      prime?(num + 1) -> num + 1
      true -> nextprime(num + 1)
    end
  end
end
