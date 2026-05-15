defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles
  """

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, take_down) when start_bottle >= take_down do
    start_bottle..(start_bottle - take_down + 1) |> Enum.map(&verse/1) |> Enum.join("\n\n")
  end

  def verse(bottle) do
    rest = bottle - 1

    """
    #{num2word(bottle) |> String.capitalize()} green #{btls(bottle)} hanging on the wall,
    #{num2word(bottle) |> String.capitalize()} green #{btls(bottle)} hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{num2word(rest)} green #{btls(rest)} hanging on the wall.\
    """
  end

  defp num2word(num) do
    case num do
      0 -> "no"
      1 -> "one"
      2 -> "two"
      3 -> "three"
      4 -> "four"
      5 -> "five"
      6 -> "six"
      7 -> "seven"
      8 -> "eight"
      9 -> "nine"
      10 -> "ten"
    end
  end

  defp btls(1), do: "bottle"
  defp btls(_), do: "bottles"
end
