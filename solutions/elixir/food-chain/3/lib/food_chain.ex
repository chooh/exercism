defmodule FoodChain do
  @animals {"fly", "spider", "bird", "cat", "dog", "goat", "cow", "horse"}

  @addt %{
    2 => "It wriggled and jiggled and tickled inside her.\n",
    3 => "How absurd to swallow a bird!\n",
    4 => "Imagine that, to swallow a cat!\n",
    5 => "What a hog, to swallow a dog!\n",
    6 => "Just opened her throat and swallowed a goat!\n",
    7 => "I don't know how she swallowed a cow!\n"
  }

  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop
    |> Enum.map(&verse/1)
    |> Enum.intersperse("\n")
    |> :erlang.iolist_to_binary()
  end

  defp verse(pos) when pos in [1, 8] do
    ["I know an old lady who swallowed a #{animal(pos)}.\n" | follow(pos)]
  end

  defp verse(pos) do
    [
      "I know an old lady who swallowed a #{animal(pos)}.\n",
      @addt[pos] | follow(pos)
    ]
  end

  defp follow(8), do: ["She's dead, of course!\n"]

  defp follow(3) do
    [
      "She swallowed the bird to catch the spider that wriggled and jiggled and tickled inside her.\n"
      | follow(2)
    ]
  end

  defp follow(1), do: ["I don't know why she swallowed the fly. Perhaps she'll die.\n"]

  defp follow(num) when num > 1,
    do: ["She swallowed the #{animal(num)} to catch the #{animal(num - 1)}.\n" | follow(num - 1)]

  defp animal(pos) when pos > 0, do: elem(@animals, pos - 1)
end
