defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    encode(string, {nil, 0}, "")
  end

  def encode("", chunk, acc), do: acc <> encode_chunk(chunk)

  def encode(<<head::utf8, rest::binary>>, {letter, counter}, acc) when head == letter,
    do: encode(rest, {letter, counter + 1}, acc)

  def encode(<<head::utf8, rest::binary>>, chunk, acc),
    do: encode(rest, {head, 1}, acc <> encode_chunk(chunk))

  def encode_chunk({_, 0}), do: ""
  def encode_chunk({letter, 1}), do: <<letter::utf8>>
  def encode_chunk({letter, counter}), do: to_string(counter) <> <<letter::utf8>>

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    decode(string, "")
  end

  def decode("", acc), do: acc

  def decode(string, acc) do
    {counter, <<letter::utf8, rest::binary>>} =
      case Integer.parse(string) do
        {counter, s} -> {counter, s}
        _ -> {1, string}
      end

    decode(rest, acc <> decode_chunk({letter, counter}))
  end

  def decode_chunk({letter, counter}), do: List.duplicate(letter, counter) |> List.to_string()
end
