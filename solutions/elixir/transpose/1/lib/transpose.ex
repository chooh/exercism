defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input) do
    strings = String.split(input, "\n")

    max_length = Enum.map(strings, &String.length/1) |> Enum.max()

    strings = Enum.map(strings, fn s -> String.pad_trailing(s, max_length, "*") end)

    out = strings |> Enum.map(&String.codepoints/1) |> List.zip() |> Enum.map(&Tuple.to_list/1)

    out
    |> Enum.map(&Kernel.to_string/1)
    |> Enum.map(&String.trim_trailing(&1, "*"))
    |> Enum.join("\n")
    |> String.replace("*", " ")
  end
end
