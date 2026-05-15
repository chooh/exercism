defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence), do: isogram?(sentence, MapSet.new())

  def isogram?(<<>>, _), do: true

  def isogram?(<<" "::utf8, rest::binary>>, set), do: isogram?(rest, set)
  def isogram?(<<"-"::utf8, rest::binary>>, set), do: isogram?(rest, set)

  def isogram?(<<head::utf8, rest::binary>>, set) do
    head = String.downcase(<<head::utf8>>)

    if MapSet.member?(set, head) do
      false
    else
      isogram?(rest, MapSet.put(set, head))
    end
  end
end
