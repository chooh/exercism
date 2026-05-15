defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(coins, target) do
    bfs([{target, []}], MapSet.new([target]), coins)
  end

  defp bfs([], _visited, _coins), do: {:error, "cannot change"}

  defp bfs([{0, hand} | _], _visited, _coins), do: {:ok, Enum.sort(hand)}

  defp bfs([{sum, hand} | rest], visited, coins) do
    IO.inspect([{sum, hand} | rest])

    next =
      for coin <- coins,
          coin <= sum,
          not MapSet.member?(visited, sum - coin) do
        {sum - coin, [coin | hand]}
      end

    new_visited =
      next
      |> Enum.map(fn {s, _} -> s end)
      |> MapSet.new()
      |> MapSet.union(visited)

    bfs(rest ++ next, new_visited, coins)
  end
end
