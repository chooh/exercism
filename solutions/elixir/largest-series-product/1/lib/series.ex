defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) do
    unless String.length(number_string) >= size and size >= 0 do
      raise ArgumentError,
        message: "the size value must be non negative and be less that the length of the string"
    end

    number_string
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> collect(size)
    |> Enum.map(&Enum.product/1)
    |> Enum.max()
  end

  defp collect(list, size) when length(list) >= size do
    head = Enum.take(list, size - 1)
    tail = Enum.drop(list, size - 1)

    {result, _} =
      Enum.reduce(tail, {[], head}, fn number, {acc, memo} ->
        {[memo ++ [number] | acc], Enum.drop(memo, 1) ++ [number]}
      end)

    Enum.reverse(result)
  end
end
