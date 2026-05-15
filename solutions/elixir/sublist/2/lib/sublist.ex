defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) when length(a) == length(b) do
    if a == b, do: :equal, else: :unequal
  end

  def compare(a, b) when length(a) > length(b) do
    if sublist?(b, a), do: :superlist, else: :unequal
  end

  def compare(a, b) when length(a) < length(b) do
    if sublist?(a, b), do: :sublist, else: :unequal
  end

  defp sublist?([], _), do: true
  defp sublist?(a, b) when length(a) > length(b), do: false
  defp sublist?(a, b), do: List.starts_with?(b, a) || sublist?(a, tl(b))
end
