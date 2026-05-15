defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position) :: integer
  def score({x, y}) do
    r = :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))

    cond do
      r <= 1.0 -> 10
      r <= 5.0 -> 5
      r <= 10.0 -> 1
      true -> 0
    end
  end
end
