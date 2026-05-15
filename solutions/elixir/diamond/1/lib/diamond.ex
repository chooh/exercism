defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    dist = letter - ?A
    len = 2 * dist + 1

    (Enum.map(0..(dist - 1)//1, fn d -> line(?A + d, d, len) end) ++
       [line(letter, dist, len)] ++
       Enum.map((dist - 1)..0//-1, fn d -> line(?A + d, d, len) end))
    |> Enum.join()
  end

  defp line(letter, dist, length, pad \\ " ")

  defp line(?A, 0, length, pad) do
    ed = div(length - 1, 2)
    String.duplicate(pad, ed) <> <<?A>> <> String.duplicate(pad, ed) <> "\n"
  end

  defp line(letter, dist, length, pad) do
    mi = dist * 2 - 1
    ed = div(length - 2 - mi, 2)

    String.duplicate(pad, ed) <>
      <<letter>> <>
      String.duplicate(pad, mi) <>
      <<letter>> <>
      String.duplicate(pad, ed) <> "\n"
  end
end
