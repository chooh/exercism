defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  """
  @spec result_for([String.t()]) :: :none | :X | :O
  def result_for(board) do
    cols = length(board)
    rows = Enum.map(board, &String.length/1) |> Enum.max()

    game = %{
      max_col: cols - 1,
      max_row: rows - 1,
      cells: to_cells(board)
    }

    # for X from left to right
    winner_x =
      0..game.max_col
      |> Enum.map(fn col -> {col, 0} end)
      |> dfs_multi(game, :X)

    # For O from top to bottom
    winner_o =
      0..game.max_row
      |> Enum.map(fn row -> {0, row} end)
      |> dfs_multi(game, :O)

    cond do
      winner_x -> :X
      winner_o -> :O
      true -> :none
    end
  end

  def to_cells(board) do
    to_cell = fn
      "X" -> :X
      "O" -> :O
      "." -> :empty
    end

    board
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, col}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {dot, row}, acc ->
        Map.put(acc, {col, row}, to_cell.(dot))
      end)
    end)
  end

  # Each cell has exactly 6 neighbors in a hex grid.
  def neighbors({col, row}, max_col, max_row) do
    [
      {col - 1, row},
      {col - 1, row + 1},
      {col, row - 1},
      {col, row + 1},
      {col + 1, row - 1},
      {col + 1, row}
    ]
    |> Enum.filter(fn {col, _row} -> col >= 0 and col <= max_col end)
    |> Enum.filter(fn {_col, row} -> row >= 0 and row <= max_row end)
  end

  def dfs_multi(cells, game, player, visited \\ MapSet.new()) do
    cells
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.filter(fn cell -> game.cells[cell] == player end)
    |> Enum.reduce_while(false, fn cell, _acc ->
      result = dfs(cell, game, player, visited)
      if result, do: {:halt, true}, else: {:cont, false}
    end)
  end

  def dfs({col, row} = cell, game, player, visited \\ MapSet.new()) do
    cond do
      player == :X and row == game.max_row ->
        true

      player == :O and col == game.max_col ->
        true

      true ->
        next_cells = neighbors(cell, game.max_col, game.max_row)
        new_visited = MapSet.put(visited, cell)
        dfs_multi(next_cells, game, player, new_visited)
    end
  end
end
