defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    candidates |> Enum.filter(&anagram?(String.downcase(&1), String.downcase(base)))
  end

  defp anagram?(a, b) when a == b, do: false

  defp anagram?(a, b), do: Enum.sort(String.to_charlist(a)) == Enum.sort(String.to_charlist(b))
end
