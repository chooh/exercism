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

  def maximum_value(items, maximum_weight) do
    items
    |> Enum.map(fn
      %{value: value, weight: weight} = item when weight <= maximum_weight ->
        value + maximum_value(List.delete(items, item), maximum_weight - weight)

      _ ->
        0
    end)
    |> Enum.max()
  end
end
