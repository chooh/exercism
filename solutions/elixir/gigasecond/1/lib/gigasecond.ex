defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}) do
    NaiveDateTime.new!(year, month, day, hours, minutes, seconds)
    |> NaiveDateTime.add(1_000_000_000)
    |> then(fn dt -> {{dt.year, dt.month, dt.day}, {dt.hour, dt.minute, dt.second}} end)
  end
end
