defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _), do: %{}

  def frequency(texts, workers) do
    workload_size = ceil(length(texts) / workers)

    texts
    |> Enum.chunk_every(workload_size)
    |> Enum.map(fn workloads ->
      Task.async(fn -> workloads |> Enum.map(&do_frequency/1) |> then(&do_merge/1) end)
    end)
    |> then(&Task.await_many/1)
    |> then(&do_merge/1)
  end

  def do_frequency(text) do
    text
    |> String.downcase()
    |> String.graphemes()
    |> Enum.filter(&(&1 =~ ~r/^[[:alpha:]]$/u))
    |> Enum.reduce(%{}, fn letter, acc ->
      Map.update(acc, letter, 1, &(&1 + 1))
    end)
  end

  @spec do_merge([map]) :: map
  def do_merge(results) do
    Enum.reduce(results, %{}, fn m1, m2 -> Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end) end)
  end
end
