defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    Enum.zip(String.graphemes(str), zigzag(rails, String.length(str)))
    |> Enum.reduce(%{}, fn {letter, rail}, acc ->
      Map.update(acc, rail, [letter], fn x -> x ++ [letter] end)
    end)
    |> Enum.to_list()
    |> Enum.map(fn {_, x} -> x end)
    |> :erlang.iolist_to_binary()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    s = String.graphemes(str)
    z = zigzag(rails, length(s))

    counts = Enum.map(1..rails, fn x -> Enum.count(z, &(&1 == x)) end)

    {letters, []} =
      Enum.reduce(counts, {[], s}, fn x, {acc, s} ->
        {head, tail} = Enum.split(s, x)
        {acc ++ [head], tail}
      end)

    map =
      letters
      |> Enum.with_index(1)
      |> Enum.into(%{}, fn {elem, index} -> {index, elem} end)

    Enum.reduce(z, {[], map}, fn z, {acc, map} ->
      {letter, map} = Map.get_and_update(map, z, &Enum.split(&1, 1))
      {acc ++ letter, map}
    end)
    |> elem(0)
    |> :erlang.iolist_to_binary()
  end

  defp zigzag(1, len), do: Stream.cycle([1]) |> Enum.take(len)
  defp zigzag(2, len), do: Stream.cycle([1, 2]) |> Enum.take(len)

  defp zigzag(rails, len) do
    (Enum.to_list(1..rails) ++ Enum.to_list((rails - 1)..2//-1))
    |> Stream.cycle()
    |> Enum.take(len)
  end
end
