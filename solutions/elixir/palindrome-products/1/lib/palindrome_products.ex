defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)

  def generate(max_factor, min_factor) when max_factor >= min_factor do
    for x <- min_factor..max_factor, y <- x..max_factor, is_palindrome(x * y), reduce: %{} do
      acc -> Map.update(acc, x * y, [[x, y]], fn list -> [[x, y] | list] end)
    end
  end

  def generate(_, _), do: raise(ArgumentError, message: "max should be greater or equal than min")

  defp is_palindrome(number) do
    str = to_string(number)

    str == String.reverse(str)
  end
end
