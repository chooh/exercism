defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true
  def chain?([{a, a}]), do: true
  def chain?([_]), do: false
  def chain?(dominoes), do: Enum.any?(all_chains(dominoes), &chained?/1)

  defp chained?(dominoes) do
    with {a, _} <- List.first(dominoes),
         {_, b} <- List.last(dominoes) do
      a == b
    end
  end

  defp all_chains(dominoes) do
    find_chains(dominoes, [])
  end

  defp find_chains([], chain), do: [Enum.reverse(chain)]

  defp find_chains(dominoes, chain) do
    for {domino, remaining} <- pick_domino(dominoes),
        next_chain <- extend_chain(domino, chain, remaining) do
      next_chain
    end
  end

  defp extend_chain(domino, [], remaining) do
    find_chains(remaining, [domino])
  end

  defp extend_chain({a, b}, [{_, c} | _] = chain, remaining) when a == c do
    find_chains(remaining, [{a, b} | chain])
  end

  defp extend_chain({a, b}, [{_, c} | _] = chain, remaining) when b == c do
    find_chains(remaining, [{b, a} | chain])
  end

  defp extend_chain(_, _, _), do: []

  defp pick_domino(dominoes) do
    dominoes
    |> Enum.with_index()
    |> Enum.map(fn {domino, index} ->
      {domino, List.delete_at(dominoes, index)}
    end)
  end
end
