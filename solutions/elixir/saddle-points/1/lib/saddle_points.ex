defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str), do: rows(str) |> transpose

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    rows = rows(str)
    cols = columns(str)
    max_rows = max_rows(rows)
    min_cols = min_cols(cols)
    c2(rows, max_rows, min_cols, 0, [])
  end

  def c2([], [], _min_cols, _i, result), do: result |> Enum.reverse()

  def c2([row | tr], [max | tm], min_cols, i, result) do
    c2(tr, tm, min_cols, i + 1, c1(row, min_cols, max, i, 0, result))
  end

  def c1([], [], _max, _i, _j, result), do: result

  def c1([v | tc], [min | tm], max, i, j, result),
    do: c1(tc, tm, max, i, j + 1, check(v, max, min, i, j, result))

  def check(val, max, min, i, j, result) do
    if val == min && val == max do
      [{i, j} | result]
    else
      result
    end
  end

  defp max_rows(rows), do: rows |> Enum.map(&Enum.max/1)
  defp min_cols(cols), do: cols |> Enum.map(&Enum.min/1)

  def transpose(m), do: transpose(m, [])

  defp transpose([], result), do: result |> Enum.map(&Enum.reverse/1)
  defp transpose([row | t], result), do: transpose(t, make_column(row, result))

  defp make_column([], []), do: []
  defp make_column([h | t], []), do: [[h] | make_column(t, [])]
  defp make_column([h | t], [rh | rt]), do: [[h | rh] | make_column(t, rt)]
end
