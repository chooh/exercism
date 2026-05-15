defmodule Connect do
  defmodule Game do
    @type position :: {non_neg_integer(), non_neg_integer()}
    @type player :: String.t()
    @type t :: %__MODULE__{
            max_col: non_neg_integer(),
            max_row: non_neg_integer(),
            board: %{position() => player()}
          }
    defstruct [:board, :max_col, :max_row]

    @spec new([String.t()]) :: Game.t()
    def new(board) do
      max_row = length(board) - 1
      max_col = (Enum.map(board, &String.length/1) |> Enum.max()) - 1

      board =
        for {line, row} <- Enum.with_index(board),
            {c, col} <- String.graphemes(line) |> Enum.with_index(),
            into: %{},
            do: {{col, row}, c}

      %Game{board: board, max_col: max_col, max_row: max_row}
    end

    def left_edge(%Game{max_row: max_row}), do: Enum.map(0..max_row, fn row -> {0, row} end)
    def top_edge(%Game{max_col: max_col}), do: Enum.map(0..max_col, fn col -> {col, 0} end)

    def player_at?(%Game{board: board}, player, {_col, _row} = pos), do: board[pos] == player

    defp end_position?(%Game{max_col: max_col}, "X", {col, _row}), do: col == max_col
    defp end_position?(%Game{max_row: max_row}, "O", {_col, row}), do: row == max_row

    def winner?(%Game{} = game, player, pos),
      do: player_at?(game, player, pos) and end_position?(game, player, pos)

    def neighbors(%Game{max_col: max_col, max_row: max_row}, {col, row}) do
      # Each cell has exactly 6 neighbors in a hex grid.
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
  end

  @doc """
  Calculates the winner (if any) of a board
  """
  @spec result_for([String.t()]) :: :none | :X | :O
  def result_for(board) do
    game = Game.new(board)

    cond do
      # for X from left to right
      dfs_multi(Game.left_edge(game), game, "X") |> elem(0) ->
        :X

      # For O from top to bottom
      dfs_multi(Game.top_edge(game), game, "O") |> elem(0) ->
        :O

      true ->
        :none
    end
  end

  @spec dfs_multi([Game.position()], Game.t(), Game.player(), MapSet.t()) ::
          {boolean(), MapSet.t()}
  defp dfs_multi(positions, game, player, visited \\ MapSet.new()) do
    positions
    |> Enum.filter(&Game.player_at?(game, player, &1))
    |> Enum.reduce_while({false, visited}, fn pos, {_, visited} ->
      {win, _} = result = dfs(pos, game, player, visited)
      if win, do: {:halt, result}, else: {:cont, result}
    end)
  end

  @spec dfs(Game.position(), Game.t(), Game.player(), MapSet.t()) :: {boolean(), MapSet.t()}
  defp dfs(pos, game, player, visited) do
    cond do
      MapSet.member?(visited, pos) ->
        {false, visited}

      Game.winner?(game, player, pos) ->
        {true, visited}

      true ->
        visited = MapSet.put(visited, pos)

        Game.neighbors(game, pos)
        |> dfs_multi(game, player, visited)
    end
  end
end
