defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(n) do
    numeral(n, "")
  end

  defp numeral(n, acc) do
    case n do
      n when n >= 1000 -> numeral(n - 1000, acc <> "M")
      n when n >= 900 -> numeral(n - 900, acc <> "CM")
      n when n >= 500 -> numeral(n - 500, acc <> "D")
      n when n >= 400 -> numeral(n - 400, acc <> "CD")
      n when n >= 100 -> numeral(n - 100, acc <> "C")
      n when n >= 90 -> numeral(n - 90, acc <> "XC")
      n when n >= 50 -> numeral(n - 50, acc <> "L")
      n when n >= 40 -> numeral(n - 40, acc <> "XL")
      n when n >= 10 -> numeral(n - 10, acc <> "X")
      n when n >= 9 -> numeral(n - 9, acc <> "IX")
      n when n >= 5 -> numeral(n - 5, acc <> "V")
      n when n >= 4 -> numeral(n - 4, acc <> "IV")
      n when n >= 1 -> numeral(n - 1, acc <> "I")
      n when n == 0 -> acc
    end
  end
end
