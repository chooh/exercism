defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  """
  @spec result_for([String.t()]) :: :none | :X | :O
  def result_for(board) do
    max_col = length(board) - 1
    max_row = (Enum.map(board, &String.length/1) |> Enum.max()) - 1

    cells =
      for {line, col} <- Enum.with_index(board),
          {c, row} <- String.graphemes(line) |> Enum.with_index(),
          into: %{},
          do: {{col, row}, c}

    game = fn
      {:player_at, pos} ->
        cells[pos]

      {:end_position?, "X", {_col, row}} ->
        row == max_row

      {:end_position?, "O", {col, _row}} ->
        col == max_col

      # Each cell has exactly 6 neighbors in a hex grid.
      {:neighbors, {col, row}} ->
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

    # for X from left to right
    winner_x =
      0..max_col
      |> Enum.map(fn col -> {col, 0} end)
      |> dfs_multi(game, "X")

    # For O from top to bottom
    winner_o =
      0..max_row
      |> Enum.map(fn row -> {0, row} end)
      |> dfs_multi(game, "O")

    cond do
      winner_x -> :X
      winner_o -> :O
      true -> :none
    end
  end

  defp dfs_multi(cells, game, player, visited \\ MapSet.new()) do
    cells
    |> Enum.reject(&MapSet.member?(visited, &1))
    |> Enum.filter(fn cell -> game.({:player_at, cell}) == player end)
    |> Enum.find_value(fn cell ->
      if game.({:end_position?, player, cell}) do
        true
      else
        next_cells = game.({:neighbors, cell})
        new_visited = MapSet.put(visited, cell)
        dfs_multi(next_cells, game, player, new_visited)
      end
    end)
  end
end
