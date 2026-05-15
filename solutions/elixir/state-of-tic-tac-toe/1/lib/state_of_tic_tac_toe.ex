defmodule StateOfTicTacToe do
  @winning_lines [
    # rows
    {0, 1, 2},
    {3, 4, 5},
    {6, 7, 8},
    # cols
    {0, 3, 6},
    {1, 4, 7},
    {2, 5, 8},
    # diagonals
    {0, 4, 8},
    {2, 4, 6}
  ]

  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    tuple_board =
      board
      |> String.replace("\n", "")
      |> String.to_charlist()

    with :ok <- check_turns(tuple_board) do
      {x_wins, o_wins} = count_wins(tuple_board)

      cond do
        # Impossible: both players won
        x_wins > 0 and o_wins > 0 ->
          {:error, "Impossible board: game should have ended after the game was won"}

        x_wins > 0 or o_wins > 0 ->
          {:ok, :win}

        Enum.any?(tuple_board, &(&1 == ?.)) ->
          {:ok, :ongoing}

        true ->
          {:ok, :draw}
      end
    end
  end

  def count_wins(board) do
    board = List.to_tuple(board)

    Enum.reduce(@winning_lines, {0, 0}, fn {i, j, k}, {xw, ow} ->
      {a, b, c} = {elem(board, i), elem(board, j), elem(board, k)}

      cond do
        a == ?X and a == b and b == c -> {xw + 1, ow}
        a == ?O and a == b and b == c -> {xw, ow + 1}
        true -> {xw, ow}
      end
    end)
  end

  def check_turns(board) do
    {xs, os} =
      board
      |> Enum.reduce({0, 0}, fn
        ?X, {x, o} -> {x + 1, o}
        ?O, {x, o} -> {x, o + 1}
        _, acc -> acc
      end)

    cond do
      xs - os >= 2 -> {:error, "Wrong turn order: X went twice"}
      os > xs -> {:error, "Wrong turn order: O started"}
      true -> :ok
    end
  end
end
