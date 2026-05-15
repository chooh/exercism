defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers) do
    Enum.map(integers, fn i ->
      <<e::4, d::7, c::7, b::7, a::7>> = <<i::32>>

      cond do
        e > 0 -> [e + 0x80, d + 0x80, c + 0x80, b + 0x80, a]
        d > 0 -> [d + 0x80, c + 0x80, b + 0x80, a]
        c > 0 -> [c + 0x80, b + 0x80, a]
        b > 0 -> [b + 0x80, a]
        true -> [a]
      end
    end)
    |> IO.iodata_to_binary()
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes), do: do_decode(bytes, nil, [])

  defp do_decode(<<>>, nil, integers), do: {:ok, Enum.reverse(integers)}
  defp do_decode(<<>>, _, _), do: {:error, "incomplete sequence"}

  defp do_decode(<<int::integer-size(8), rest::binary>>, acc, integers) do
    if int >= 0x80 do
      new_acc =
        if acc do
          acc * 0x80 + int - 0x80
        else
          int - 0x80
        end

      do_decode(rest, new_acc, integers)
    else
      new_int =
        if acc do
          acc * 0x80 + int
        else
          int
        end

      do_decode(rest, nil, [new_int | integers])
    end
  end
end
