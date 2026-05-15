defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer

  def maximum_value([], _), do: 0

  def maximum_value([%{value: value, weight: weight}], maximum_weight)
      when weight <= maximum_weight,
      do: value

  def maximum_value([_], _), do: 0

  def maximum_value([%{value: value, weight: weight} | rest], maximum_weight) do
    with_head_item =
      if weight <= maximum_weight do
        value + maximum_value(rest, maximum_weight - weight)
      else
        0
      end

    Enum.max([with_head_item, maximum_value(rest, maximum_weight)])
  end
end
