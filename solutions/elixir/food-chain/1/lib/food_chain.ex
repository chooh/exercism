defmodule FoodChain do
  @food %{
    1 => "fly",
    2 => "spider",
    3 => "bird",
    4 => "cat",
    5 => "dog",
    6 => "goat",
    7 => "cow",
    8 => "horse"
  }

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
    Enum.map(start..stop, &verse/1)
    |> Enum.intersperse("\n")
    |> :erlang.iolist_to_binary()
  end

  def verse(8) do
    """
    I know an old lady who swallowed a horse.
    She's dead, of course!
    """
  end

  def verse(1) do
    [
      "I know an old lady who swallowed a fly.\n",
      "I don't know why she swallowed the fly. Perhaps she'll die.\n"
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

  def animal("spider"), do: "spider that wriggled and jiggled and tickled inside her"
  def animal(name), do: name
end
