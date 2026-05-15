defmodule Transmission do
  @doc """
  Return the transmission sequence for a message.
  """
  @spec get_transmit_sequence(binary()) :: binary()
  def get_transmit_sequence(message) do
    message
    |> Stream.unfold(fn
      <<>> -> nil
      <<x::bitstring-size(7), rest::bitstring>> -> {x, rest}
      <<x::bitstring>> -> {<<x::bitstring, 0::size(7 - bit_size(x))>>, <<>>}
    end)
    |> Stream.map(&add_parity_bit/1)
    |> Enum.to_list()
    |> :erlang.list_to_binary()
  end

  @doc """
  Return the message decoded from the received transmission.
  """
  @spec decode_message(binary()) :: {:ok, binary()} | {:error, String.t()}
  def decode_message(received_data), do: decode_message(received_data, [])

  def decode_message(<<>>, acc) do
    bitstring = for i <- Enum.reverse(acc), do: i, into: <<>>
    bytes_count = bit_size(bitstring) |> div(8)
    <<data::binary-size(bytes_count), _rest::bitstring>> = bitstring
    {:ok, data}
  end

  def decode_message(<<byte::binary-size(1), rest::binary>>, acc) do
    if check_parity_bit(byte) do
      decode_message(rest, [drop_parity_bit(byte) | acc])
    else
      {:error, "wrong parity"}
    end
  end

  @spec add_parity_bit(<<_::7>>) :: <<_::8>>
  defp add_parity_bit(<<v::size(7)>>) do
    ones = count_ones(v)
    bit = rem(ones, 2)
    <<v::7, bit::1>>
  end

  @spec check_parity_bit(<<_::8>>) :: boolean()
  defp check_parity_bit(<<v>>) do
    ones = count_ones(v)
    rem(ones, 2) == 0
  end

  @spec drop_parity_bit(<<_::8>>) :: <<_::7>>
  defp drop_parity_bit(<<x::bitstring-size(7), _::1>>), do: x

  # Brian Kernighan’s bit-count algorithm
  defp count_ones(v), do: count_ones(v, 0)
  defp count_ones(0, acc), do: acc
  defp count_ones(v, acc), do: count_ones(Bitwise.&&&(v, v - 1), acc + 1)
end
