defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key), do: bsearch(numbers, key, 0, tuple_size(numbers) - 1)

  defp bsearch({}, _key, _, _), do: :not_found
  defp bsearch(_numbers, _key, min, max) when min > max, do: :not_found

  defp bsearch(numbers, key, min, max) do
    idx = div(min + max, 2)
    val = elem(numbers, idx)

    cond do
      key == val -> {:ok, idx}
      key > val -> bsearch(numbers, key, idx + 1, max)
      key < val -> bsearch(numbers, key, min, idx - 1)
    end
  end
end
