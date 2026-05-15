defmodule RelativeDistance do
  @doc """
  Find the degree of separation of two members given a given family tree.
  """
  @spec degree_of_separation(
          family_tree :: %{String.t() => [String.t()]},
          person_a :: String.t(),
          person_b :: String.t()
        ) :: nil | pos_integer()
  def degree_of_separation(family_tree, person_a, person_b) do
    build_graph(family_tree) |> bfs(person_a, person_b, MapSet.new(), 0)
  end

  defp bfs(_graph, start, target, _visited, distance) when start == target, do: distance

  defp bfs(graph, start, target, visited, distance) do
    if MapSet.member?(visited, start) do
      nil
    else
      Enum.map(graph[start], fn child ->
        bfs(graph, child, target, MapSet.put(visited, start), distance + 1)
      end)
      |> Enum.min()
    end
  end

  defp build_graph(family_tree) do
    Enum.reduce(family_tree, %{}, fn {parent, children}, acc ->
      # Add parent ↔ child edges
      acc =
        Enum.reduce(children, acc, fn child, acc ->
          acc
          |> Map.update(parent, [child], &[child | &1])
          |> Map.update(child, [parent], &[parent | &1])
        end)

      # Add sibling ↔ sibling edges
      acc =
        for a <- children, b <- children, a != b, reduce: acc do
          acc ->
            acc
            |> Map.update(a, [b], &[b | &1])
            |> Map.update(b, [a], &[a | &1])
        end

      acc
    end)
    |> Enum.map(fn {k, v} -> {k, Enum.uniq(v)} end)
    |> Enum.into(%{})
  end
end
