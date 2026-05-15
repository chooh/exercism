defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(count) when is_number(count) and count > 0 do
    Stream.unfold({nil, nil}, fn acc ->
      case acc do
        {nil, nil} ->
          {2, {nil, 2}}

        {nil, 2} ->
          {1, {2, 1}}

        {a, b} ->
          c = a + b
          {c, {b, c}}
      end
    end)
    |> Enum.take(count)
  end

  def generate(_), do: raise(ArgumentError, "count must be specified as an integer >= 1")
end
