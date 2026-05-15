defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn = String.replace(isbn, "-", "")

    if String.match?(isbn, ~r/^\d{9}(\d|X)$/) do
      isbn
      |> String.codepoints()
      |> Enum.map(fn
        "-" -> nil
        "X" -> 10
        digit -> String.to_integer(digit)
      end)
      |> Enum.reject(&Kernel.is_nil/1)
      |> Enum.zip(10..1)
      |> Enum.map(fn {a, b} -> a * b end)
      |> Enum.sum()
      |> then(fn sum -> rem(sum, 11) == 0 end)
    else
      false
    end
  end
end
