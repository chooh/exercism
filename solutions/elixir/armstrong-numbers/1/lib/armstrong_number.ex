defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(0), do: true

  def valid?(number) do
    d = digits(number)
    l = Enum.count(d)
    number == Enum.map(d, fn n -> :math.pow(n, l) end) |> Enum.reduce(&Kernel.+/2)
  end

  defp digits(0), do: []

  defp digits(num) do
    [rem(num, 10) | digits(div(num, 10))]
  end
end
