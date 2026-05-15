defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite(strings) when is_list(strings) do
    ["And all for the want of a #{hd(strings)}.\n" | recite(strings, [])]
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp recite([fst, snd | tail], acc) do
    recite([snd | tail], ["For want of a #{fst} the #{snd} was lost." | acc])
  end

  defp recite([_], acc), do: acc
end
