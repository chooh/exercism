defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode(str, rails) do
    fence(rails, String.length(str))
    |> Stream.zip(String.graphemes(str))
    |> Enum.sort_by(fn {{rail, _pos}, _letter} -> rail end)
    |> text()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode(str, rails) do
    fence(rails, String.length(str))
    |> Enum.sort_by(fn {rail, _pos} -> rail end)
    |> Stream.zip(String.graphemes(str))
    |> Enum.sort_by(fn {{_rail, pos}, _letter} -> pos end)
    |> text()
  end

  defp fence(rails, length) do
    zigzag(rails) |> Stream.take(length) |> Stream.zip(0..(length - 1))
  end

  defp zigzag(1), do: Stream.cycle([1])
  defp zigzag(2), do: Stream.cycle([1, 2])

  defp zigzag(rails) do
    Stream.concat(1..(rails - 1), rails..2//-1) |> Stream.cycle()
  end

  defp text(fence), do: Enum.map(fence, &elem(&1, 1)) |> Enum.join()
end
