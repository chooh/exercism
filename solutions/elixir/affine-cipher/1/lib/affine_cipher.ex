defmodule AffineCipher do
  # m is the length of the alphabet. For the Roman alphabet m is 26.
  @m ?z - ?a + 1

  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    if Integer.gcd(a, @m) == 1 do
      encoded =
        message
        |> String.downcase()
        |> String.replace(~r/[\W_]/, "")
        |> String.codepoints()
        |> Enum.map(fn
          <<char::utf8>> when char in ?a..?z ->
            i = char - ?a
            d = (a * i + b) |> rem(@m)
            <<d + ?a::utf8>>

          c ->
            c
        end)
        |> Enum.chunk_every(5)
        |> Enum.map(&Enum.join/1)
        |> Enum.join(" ")

      {:ok, encoded}
    else
      {:error, "a and m must be coprime."}
    end
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), encrypted :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    if Integer.gcd(a, @m) == 1 do
      decoded =
        encrypted
        |> String.codepoints()
        |> Enum.reject(&(&1 == " "))
        |> Enum.map(fn
          <<char::utf8>> when char in ?a..?z ->
            y = char - ?a
            d = rem(mod_inverse2(a, @m) * (y - b), @m)
            d = if d < 0, do: d + @m, else: d
            <<d + ?a::utf8>>

          c ->
            c
        end)
        |> Enum.join()

      {:ok, decoded}
    else
      {:error, "a and m must be coprime."}
    end
  end

  defp mod_inverse2(a, m) do
    Stream.unfold(1, &{&1, &1 + 1})
    |> Stream.filter(fn x -> rem(a * x, m) == 1 end)
    |> Enum.take(1)
    |> hd()
  end
end
