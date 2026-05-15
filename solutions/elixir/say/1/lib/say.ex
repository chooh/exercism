defmodule Say do
  @alph %{
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
    90 => "ninety",
    100 => "hundred"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(0), do: {:ok, "zero"}

  def in_english(number) when number > 0 and number < 20 do
    {:ok, Map.get(@alph, number)}
  end

  def in_english(number) when number >= 20 and number < 100 do
    remainder = rem(number, 10)

    if remainder == 0 do
      {:ok, Map.get(@alph, number - remainder)}
    else
      {:ok, rest} = in_english(remainder)
      {:ok, Map.get(@alph, number - remainder) <> "-" <> rest}
    end
  end

  def in_english(number) when number >= 100 and number < 1_000 do
    remainder = rem(number, 100)
    hundreds = div(number, 100)

    if remainder == 0 do
      {:ok, Map.get(@alph, hundreds) <> " hundred"}
    else
      {:ok, rest} = in_english(remainder)
      {:ok, Map.get(@alph, hundreds) <> " hundred " <> rest}
    end
  end

  def in_english(number) when number >= 1_000 and number < 1_000_000 do
    remainder = rem(number, 1_000)
    thousands = div(number, 1_000)

    {:ok, head} = in_english(thousands)

    if remainder == 0 do
      {:ok, head <> " thousand"}
    else
      {:ok, rest} = in_english(remainder)
      {:ok, head <> " thousand " <> rest}
    end
  end

  def in_english(number) when number >= 1_000_000 and number < 1_000_000_000 do
    remainder = rem(number, 1_000_000)
    millions = div(number, 1_000_000)

    {:ok, head} = in_english(millions)

    if remainder == 0 do
      {:ok, head <> " million"}
    else
      {:ok, rest} = in_english(remainder)
      {:ok, head <> " million " <> rest}
    end
  end

  def in_english(number) when number >= 1_000_000_000 and number < 1_000_000_000_000 do
    remainder = rem(number, 1_000_000_000)
    billions = div(number, 1_000_000_000)

    {:ok, head} = in_english(billions)

    if remainder == 0 do
      {:ok, head <> " billion"}
    else
      {:ok, rest} = in_english(remainder)
      {:ok, head <> " billion " <> rest}
    end
  end

  def in_english(_) do
    {:error, "number is out of range"}
  end
end
