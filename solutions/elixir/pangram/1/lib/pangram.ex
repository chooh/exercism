defmodule Pangram do
  @doc """
  Determines if a word or sentence is a pangram.
  A pangram is a sentence using every letter of the alphabet at least once.

  Returns a boolean.

    ## Examples

      iex> Pangram.pangram?("the quick brown fox jumps over the lazy dog")
      true

  """

  @spec pangram?(String.t()) :: boolean
  def pangram?(sentence) do
    true

    sentence
    |> String.downcase()
    |> String.graphemes()
    |> Enum.reduce(MapSet.new(), fn
      letter, set when letter >= <<?a>> and letter <= <<?z>> -> MapSet.put(set, letter)
      _, set -> set
    end)
    |> then(fn set -> MapSet.size(set) == 26 end)
  end
end
