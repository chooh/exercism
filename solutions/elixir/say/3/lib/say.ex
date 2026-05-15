defmodule Say do
  @dict %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number not in 0..999_999_999_999,
    do: {:error, "number is out of range"}

  def in_english(number), do: {:ok, do_in_english(number, "")}

  defp do_in_english(0, ""), do: "zero"

  defp do_in_english(0, acc), do: :erlang.iolist_to_binary(acc)
  defp do_in_english(n, acc) when n < 20, do: do_in_english(0, [acc, @dict[n]])

  defp do_in_english(n, acc) when n < 100 do
    tens = div(n, 10) * 10
    rest = n - tens

    if rest == 0 do
      do_in_english(rest, [acc, @dict[tens]])
    else
      do_in_english(rest, [acc, @dict[tens], "-"])
    end
  end

  defp do_in_english(n, acc) do
    {divisor, text} =
      cond do
        n < 1_000 -> {100, "hundred"}
        n < 1_000_000 -> {1_000, "thousand"}
        n < 1_000_000_000 -> {1_000_000, "million"}
        n < 1_000_000_000_000 -> {1_000_000_000, "billion"}
      end

    units = div(n, divisor)
    rest = rem(n, divisor)
    spacer = if rest == 0, do: [], else: [" "]

    do_in_english(rest, [acc, do_in_english(units, []), " ", text, spacer])
  end
end
