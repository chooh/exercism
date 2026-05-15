defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.downcase()
    |> String.replace(~r/[\W_]/, "")
    |> String.codepoints()
    |> Enum.map(&rotate/1)
    |> Enum.chunk_every(5)
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.downcase()
    |> String.replace(~r/[\W_]/, "")
    |> String.codepoints()
    |> Enum.map(&rotate/1)
    |> Enum.join()
  end

  defp rotate(<<x::utf8>>) when x >= ?a and x <= ?z, do: <<219 - x>>
  defp rotate(x), do: x
end
