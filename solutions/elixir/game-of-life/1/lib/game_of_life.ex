defmodule GameOfLife do
  @doc """
  Apply the rules of Conway's Game of Life to a grid of cells
  """

  @spec tick(matrix :: list(list(0 | 1))) :: list(list(0 | 1))
  def tick([]), do: []

  def tick(matrix) do
    matrix |> to_grid() |> next_grid() |> from_grid()
  end

  def to_grid(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, x} -> Enum.with_index(row, fn el, y -> {{x, y}, el} end) end)
    |> Enum.into(%{})
  end

  def from_grid(grid) do
    {max_x, max_y} = grid |> Map.keys() |> Enum.max()

    Enum.map(0..max_x, fn x -> Enum.map(0..max_y, fn y -> Map.get(grid, {x, y}) end) end)
  end

  def neighbors({x, y}) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0}, do: {x + dx, y + dy}
  end

  def live_neighbors(grid, cell) do
    cell |> neighbors() |> Enum.map(fn cell -> Map.get(grid, cell, 0) end) |> Enum.sum()
  end

  # Any live cell with two or three live neighbors lives on.
  def next_state(1, live_neighbors) when live_neighbors in [2, 3], do: 1
  # Any dead cell with exactly three live neighbors becomes a live cell.
  def next_state(0, 3), do: 1
  # All other cells die or stay dead.
  def next_state(_, _), do: 0

  def next_grid(grid) do
    grid
    |> Enum.map(fn {cell, value} -> {cell, next_state(value, live_neighbors(grid, cell))} end)
    |> Enum.into(%{})
  end
end
