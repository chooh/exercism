defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) when input_base >= 2 and output_base >= 2 do
    with {:ok, number} <- convert_from_input(digits, input_base),
         {:ok, list} <- convert_to_output(number, output_base) do
      {:ok, if(list == [], do: [0], else: list)}
    else
      err -> err
    end
  end

  def convert(_, _, output_base) when output_base >= 2, do: {:error, "input base must be >= 2"}
  def convert(_, _, _), do: {:error, "output base must be >= 2"}

  defp convert_from_input([], _), do: {:ok, 0}

  defp convert_from_input(digits, input_base) do
    if Enum.any?(digits, fn digit -> digit < 0 or digit >= input_base end) do
      {:error, "all digits must be >= 0 and < input base"}
    else
      {number, _} =
        digits
        |> Enum.reverse()
        |> Enum.reduce({0, 0}, fn digit, {num, pos} ->
          {num +
             digit *
               Integer.pow(input_base, pos), pos + 1}
        end)

      {:ok, number}
    end
  end

  defp convert_to_output(number, output_base) do
    list =
      Stream.unfold(number, fn
        0 -> nil
        n -> {rem(n, output_base), div(n, output_base)}
      end)
      |> Enum.to_list()
      |> Enum.reverse()

    {:ok, list}
  end
end
