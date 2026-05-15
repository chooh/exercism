defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase
    |> String.split(~r/_|[^\w\d\-]/u)
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.reduce(%{}, fn
      word, acc -> Map.get_and_update(acc, word, fn
        nil -> {nil, 1}
        i -> { i, i + 1 }
      end)
      |> elem(1)
    end)
  end
end
