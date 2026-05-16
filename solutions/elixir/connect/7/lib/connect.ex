defmodule Connect do
  defmodule Game do
    @type position :: {non_neg_integer(), non_neg_integer()}
    @type player :: :X | :O
    @type t :: %__MODULE__{
            max_col: non_neg_integer(),
            max_row: non_neg_integer(),
            board: %{position() => player()}
          }
    defstruct [:board, :max_col, :max_row]

    @spec new([String.t()]) :: Game.t()
    def new(board) do
      max_row = length(board) - 1
      max_col = String.length(hd(board)) - 1

      board =
        for {line, row} <- Enum.with_index(board),
            {c, col} <- String.graphemes(line) |> Enum.with_index(),
            into: %{},
            do: {{col, row}, to_player(c)}

      %Game{board: board, max_col: max_col, max_row: max_row}
    end

    @spec starting_edge(Game.t(), Game.player()) :: [Game.position()]
    def starting_edge(%Game{} = game, :X), do: left_edge(game)
    def starting_edge(%Game{} = game, :O), do: top_edge(game)

    @spec player_at?(Game.t(), Game.player(), Game.position()) :: boolean()
    def player_at?(%Game{board: board}, player, {_col, _row} = pos), do: board[pos] == player

    @spec end_position?(Game.t(), Game.player(), Game.position()) :: boolean()
    def end_position?(%Game{max_col: max_col}, :X, {col, _row}), do: col == max_col
    def end_position?(%Game{max_row: max_row}, :O, {_col, row}), do: row == max_row

    @spec neighbors(Game.t(), Game.position()) :: [Game.position()]
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
      |> Enum.filter(fn {col, row} ->
        col in 0..max_col and row in 0..max_row
      end)
    end

    defp to_player("X"), do: :X
    defp to_player("O"), do: :O
    defp to_player(_), do: nil

    defp left_edge(%Game{max_row: max_row}), do: Enum.map(0..max_row, fn row -> {0, row} end)
    defp top_edge(%Game{max_col: max_col}), do: Enum.map(0..max_col, fn col -> {col, 0} end)
  end

  @doc """
  Calculates the winner (if any) of a board
  """
  @spec result_for([String.t()]) :: :none | :X | :O
  def result_for(board) do
    game = Game.new(board)

    cond do
      has_winning_path?(game, :X) -> :X
      has_winning_path?(game, :O) -> :O
      true -> :none
    end
  end

  defp has_winning_path?(game, player) do
    starts = Game.starting_edge(game, player)
    search(starts, game, player, MapSet.new()) |> elem(0)
  end

  @spec search([Game.position()], Game.t(), Game.player(), MapSet.t(Game.position())) ::
          {boolean(), MapSet.t(Game.position())}
  defp search([], _game, _player, visited), do: {false, visited}

  defp search([pos | rest], game, player, visited) do
    cond do
      MapSet.member?(visited, pos) ->
        search(rest, game, player, visited)

      not Game.player_at?(game, player, pos) ->
        search(rest, game, player, visited)

      Game.end_position?(game, player, pos) ->
        {true, visited}

      true ->
        visited = MapSet.put(visited, pos)

        case search(Game.neighbors(game, pos), game, player, visited) do
          {true, v} -> {true, v}
          {false, v} -> search(rest, game, player, v)
        end
    end
  end
end
