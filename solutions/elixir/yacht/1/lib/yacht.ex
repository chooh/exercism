defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(:yacht, dice) do
    values = count_numbers(dice) |> Map.values()

    case values do
      [5] -> 50
      _ -> 0
    end
  end

  def score(:ones, dice), do: count_numbers(dice) |> Map.get(1, 0)

  def score(:twos, dice), do: count_numbers(dice) |> Map.get(2, 0) |> then(&(&1 * 2))

  def score(:threes, dice), do: count_numbers(dice) |> Map.get(3, 0) |> then(&(&1 * 3))

  def score(:fours, dice), do: count_numbers(dice) |> Map.get(4, 0) |> then(&(&1 * 4))

  def score(:fives, dice), do: count_numbers(dice) |> Map.get(5, 0) |> then(&(&1 * 5))

  def score(:sixes, dice), do: count_numbers(dice) |> Map.get(6, 0) |> then(&(&1 * 6))

  def score(:full_house, dice) do
    acc = count_numbers(dice)

    if Enum.sort(Map.values(acc)) == [2, 3] do
      Enum.sum(dice)
    else
      0
    end
  end

  def score(:four_of_a_kind, dice) do
    acc = count_numbers(dice)

    case Enum.find(acc, fn {_, count} -> count >= 4 end) do
      {d, _} -> d * 4
      _ -> 0
    end
  end

  def score(:little_straight, dice) do
    if Enum.sort(dice) == [1, 2, 3, 4, 5], do: 30, else: 0
  end

  def score(:big_straight, dice) do
    if Enum.sort(dice) == [2, 3, 4, 5, 6], do: 30, else: 0
  end

  def score(:choice, dice), do: Enum.sum(dice)

  @spec count_numbers(dice :: [integer]) :: map()
  def count_numbers(dice) do
    Enum.reduce(dice, %{}, fn el, acc -> Map.update(acc, el, 1, &(&1 + 1)) end)
  end
end
