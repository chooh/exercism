defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    number = String.replace(number, " ", "")

    if Regex.match?(~r/[^\d]/, number) || String.length(number) < 2 do
      false
    else
      number
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> valid_numbers()
    end
  end

  def valid_numbers(list) do
    list
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
