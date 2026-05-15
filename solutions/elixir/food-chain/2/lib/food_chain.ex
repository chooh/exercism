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

  def verse(8 = pos) do
    ["I know an old lady who swallowed a #{animal(pos)}.\n" | follow(pos)]
  end

  defp follow(8), do: ["She's dead, of course!\n"]

  defp follow(num),
    do: [
      "She swallowed the #{animal(num)} to catch the #{animal(num - 1)}.\n"
      | follow(num - 1)
    ]

  defp follow(1), do: ["I don't know why she swallowed the fly. Perhaps she'll die.\n"]

  def verse(1) do
    [
      "I know an old lady who swallowed a fly.\n"
    ]
  end

  def verse(pos) do
    [
      "I know an old lady who swallowed a #{@food[pos]}.\n",
      @addt[pos],
      Enum.map((pos - 1)..1//-1, fn p ->
        "She swallowed the #{@food[p + 1]} to catch the #{@food[p] |> animal()}.\n"
      end),
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
    ]

    # |> Enum.reject(&is_nil/1)
  end

  defp animal(pos), do: elem(@animals, pos - 1)
end
