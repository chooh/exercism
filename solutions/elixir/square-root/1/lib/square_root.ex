defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    do_calc(radicand, {0, radicand + 1})
  end

  defp do_calc(_, {l, r}) when l == r - 1, do: l

  defp do_calc(y, {l, r}) do
    m = div(l + r, 2)

    if m * m <= y do
      do_calc(y, {m, r})
    else
      do_calc(y, {l, m})
    end
  end
end
