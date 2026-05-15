defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(1), do: [row(1)]
  def rows(num), do: rows(num - 1) ++ [row(num)]

  defp row(1), do: [1]
  defp row(n) do
    p = row(n-1)
    Enum.zip(p ++ [0], [0|p])
    |> Enum.map(fn ({x,y}) -> x + y end)
  end
end
