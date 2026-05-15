defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    cond do
      a + b < c || b + c < a || c + a < b -> {:error, "side lengths violate triangle inequality"}
      a == b && b == c -> {:ok, :equilateral}
      a == b || b == c || c == a -> {:ok, :isosceles}
      true -> {:ok, :scalene}
    end
  end
end
