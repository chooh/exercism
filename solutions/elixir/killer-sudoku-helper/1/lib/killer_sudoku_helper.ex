defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(%{exclude: exclude, size: 1, sum: sum}) when sum > 0 do
    unless Enum.member?(exclude, sum) do
      [[sum]]
    else
      []
    end
  end

  def combinations(%{exclude: _exclude, size: 1, sum: _sum}) do
    []
  end

  def combinations(%{exclude: exclude, size: size, sum: sum}) do
    Enum.reduce(Enum.to_list(1..9) -- exclude, [], fn i, acc ->
      downstream =
        combinations(%{exclude: Enum.to_list(1..i) ++ exclude, size: size - 1, sum: sum - i})

      acc ++ Enum.map(downstream, &[i | &1])
    end)
  end
end
