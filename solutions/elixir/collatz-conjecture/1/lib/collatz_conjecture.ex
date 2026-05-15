defmodule CollatzConjecture do
  import Integer, only: [is_even: 1, is_odd: 1]

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when input > 0 do
    Stream.unfold(input, fn
      1 -> nil
      x -> {x, coco(x)}
    end)
    |> Enum.to_list()
    |> length()
  end

  defp coco(input) when is_odd(input), do: input * 3 + 1
  defp coco(input) when is_even(input), do: div(input, 2)
end
