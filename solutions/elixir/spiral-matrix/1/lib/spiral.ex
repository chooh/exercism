defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(dimension) do
    sum = dimension ** 2
    map = Enum.zip(stepper(sum), 1..sum) |> Enum.into(%{})

    Enum.map(0..(dimension - 1), fn j ->
      Enum.map(0..(dimension - 1), fn i -> map[{i, j}] end)
    end)
  end

  def ladder(sum) do
    Stream.unfold({0, true, sum}, fn
      {_, _, 0} -> nil
      {i, false, sum} -> {i, {i, true, sum - i}}
      {i, true, sum} -> {i + 1, {i + 1, false, sum - (i + 1)}}
    end)
    |> Enum.to_list()
    |> Enum.reverse()
  end

  def stepper(sum) do
    directions = Stream.cycle([:right, :down, :left, :up])

    Stream.zip(ladder(sum), directions)
    |> Enum.reduce([], fn {count, direction}, list ->
      op = fn
        {x, y}, :right -> {x + 1, y}
        {x, y}, :down -> {x, y + 1}
        {x, y}, :left -> {x - 1, y}
        {x, y}, :up -> {x, y - 1}
      end

      1..count
      |> Enum.reduce(list, fn
        _, [] ->
          [{0, 0}]

        _, acc ->
          [op.(hd(acc), direction) | acc]
      end)
    end)
    |> Enum.reverse()
  end
end
