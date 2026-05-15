defmodule EliudsEggs do
  @doc """
  Given the number, count the number of eggs.
  """
  @spec egg_count(number :: integer()) :: non_neg_integer()
  def egg_count(number), do: egg_count(number, 0)

  defp egg_count(number, eggs) when number in [1, 2], do: eggs

  defp egg_count(number, eggs) do
    egg_count(div(number, 2), eggs + if(rem(number, 2) == 1, do: 1, else: 0))
  end
end
