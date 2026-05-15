defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) when minute < 0, do: new(hour - 1, minute + 60)
  def new(hour, minute) when minute >= 60, do: new(hour + 1, minute - 60)
  def new(hour, minute) when hour < 0, do: new(hour + 24, minute)
  def new(hour, minute) when hour >= 24, do: new(hour - 24, minute)
  def new(hour, minute), do: %Clock{hour: hour, minute: minute}

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end

defimpl String.Chars, for: Clock do
  def to_string(%Clock{hour: hour, minute: minute}) do
    String.pad_leading(Kernel.to_string(hour), 2, "0") <>
      ":" <>
      String.pad_leading(Kernel.to_string(minute), 2, "0")
  end
end
