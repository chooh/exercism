defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number = String.replace(number, " ", "")

    cond do
      String.match?(number, ~r/[^\d]/) -> false
      String.length(number) <= 1 -> false
      true -> luhn(number)
    end
  end

  defp luhn(number) do
    number
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.reverse()
    |> Enum.chunk_every(2)
    |> Enum.flat_map(fn
      [a, b] when b < 5 -> [a, b * 2]
      [a, b] -> [a, b * 2 - 9]
      [a] -> [a]
    end)
    |> Enum.sum()
    |> then(fn x -> rem(x, 10) == 0 end)
  end
end
