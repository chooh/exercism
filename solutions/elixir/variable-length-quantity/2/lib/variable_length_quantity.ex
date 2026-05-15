defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    integers
    |> Enum.map(&do_encode(&1, 0, []))
    |> IO.iodata_to_binary()
  end

  defp do_encode(integer, bit, acc) when integer >= 0x80 do
    do_encode(div(integer, 0x80), 1, [<<bit::1, integer::7>> | acc])
  end

  defp do_encode(integer, bit, acc) do
    [<<bit::1, integer::7>> | acc]
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: do_decode(bytes, nil, [])

  defp do_decode(<<>>, nil, integers), do: {:ok, Enum.reverse(integers)}
  defp do_decode(<<>>, _, _), do: {:error, "incomplete sequence"}

  defp do_decode(<<byte::size(8), rest::binary>>, acc, integers) when byte >= 0x80 do
    do_decode(rest, (acc || 0) * 0x80 + byte - 0x80, integers)
  end

  defp do_decode(<<byte::size(8), rest::binary>>, acc, integers) do
    do_decode(rest, nil, [(acc || 0) * 0x80 + byte | integers])
  end
end
