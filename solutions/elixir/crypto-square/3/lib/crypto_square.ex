defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[[:^alnum:]]/, "")
    |> normalized_encode()
  end

  defp normalized_encode(""), do: ""

  defp normalized_encode(normalized) do
    sq = :math.sqrt(String.length(normalized))
    {r, c} = {ceil(sq), round(sq)}

    padded = String.pad_trailing(normalized, c * r)

    for j <- 0..(r - 1),
        i <- 0..(c - 1) do
      String.at(padded, i * r + j)
    end
    |> Enum.chunk_every(c)
    |> Enum.map(&Enum.join/1)
    |> Enum.join(" ")
  end
end
