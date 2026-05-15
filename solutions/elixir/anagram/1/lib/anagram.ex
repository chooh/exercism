defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates |> Enum.filter(&is_anagram(String.downcase(&1), String.downcase(base)))
  end

  defp is_anagram(a, b) when a == b, do: false

  defp is_anagram(a, b), do: Enum.sort(String.to_charlist(a)) == Enum.sort(String.to_charlist(b))
end
