defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    beginning = Date.new!(year, month, 1)
    ending = Date.end_of_month(beginning)
    day_of_week = to_day_of_week(weekday)

    skip =
      case schedule do
        :first -> 0
        :second -> 7
        :third -> 14
        :fourth -> 21
        :last -> ending.day - 7
        :teenth -> 12
      end

    Date.range(beginning, ending)
    |> Enum.drop(skip)
    |> Enum.find(fn date -> Date.day_of_week(date) == day_of_week end)
  end

  @spec to_day_of_week(weekday) :: Calendar.day_of_week()
  defp to_day_of_week(weekday) do
    case weekday do
      :monday -> 1
      :tuesday -> 2
      :wednesday -> 3
      :thursday -> 4
      :friday -> 5
      :saturday -> 6
      :sunday -> 7
      _ -> raise ArgumentError, "expected a weekday"
    end
  end
end
