defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: 1, sum: sum}) when sum > 0 do
    if Enum.member?(exclude, sum), do: [], else: [[sum]]
  end

  def combinations(%{exclude: _exclude, size: 1, sum: _sum}) do
    []
  end

  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    Enum.flat_map(Enum.to_list(1..9) -- exclude, fn i ->
      combinations(%{exclude: Enum.to_list(1..i) ++ exclude, size: size - 1, sum: sum - i})
      |> Enum.map(&[i | &1])
    end)
  end
end
