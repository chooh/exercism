defmodule OcrNumbers do
  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    cond do
      Kernel.rem(length(input), 4) != 0 ->
        {:error, "invalid line count"}

      Enum.any?(input, fn line -> Kernel.rem(String.length(line), 3) != 0 end) ->
        {:error, "invalid column count"}

      true ->
        {:ok, input |> Enum.chunk_every(4) |> Enum.map(&convert_line(&1)) |> Enum.join(",")}
    end
  end

  defp convert_line(input, acc \\ "") do
    if Enum.all?(input, fn x -> x == "" end) do
      acc
    else
      {digit, rest} = input |> Enum.map(&String.split_at(&1, 3)) |> Enum.unzip()
      convert_line(rest, acc <> convert_digit(digit))
    end
  end

  defp convert_digit([
         " _ ",
         "| |",
         "|_|",
         "   "
       ]),
       do: "0"

  defp convert_digit([
         "   ",
         "  |",
         "  |",
         "   "
       ]),
       do: "1"

  defp convert_digit([
         " _ ",
         " _|",
         "|_ ",
         "   "
       ]),
       do: "2"

  defp convert_digit([
         " _ ",
         " _|",
         " _|",
         "   "
       ]),
       do: "3"

  defp convert_digit([
         "   ",
         "|_|",
         "  |",
         "   "
       ]),
       do: "4"

  defp convert_digit([
         " _ ",
         "|_ ",
         " _|",
         "   "
       ]),
       do: "5"

  defp convert_digit([
         " _ ",
         "|_ ",
         "|_|",
         "   "
       ]),
       do: "6"

  defp convert_digit([
         " _ ",
         "  |",
         "  |",
         "   "
       ]),
       do: "7"

  defp convert_digit([
         " _ ",
         "|_|",
         "|_|",
         "   "
       ]),
       do: "8"

  defp convert_digit([
         " _ ",
         "|_|",
         " _|",
         "   "
       ]),
       do: "9"

  defp convert_digit(_input), do: "?"
end
