defmodule SwiftScheduling do
  @doc """
  Convert delivery date descriptions to actual delivery dates, based on when the meeting started.
  """
  @spec delivery_date(NaiveDateTime.t(), String.t()) :: NaiveDateTime.t()
  def delivery_date(meeting_date, "NOW") do
    NaiveDateTime.shift(meeting_date, hour: 2)
  end

  def delivery_date(meeting_date, "ASAP") do
    {:ok, midday} =
      NaiveDateTime.new(NaiveDateTime.to_date(meeting_date), ~T[13:00:00])

    if NaiveDateTime.before?(meeting_date, midday) do
      NaiveDateTime.shift(midday, hour: 4)
    else
      NaiveDateTime.shift(midday, day: 1)
    end
  end

  def delivery_date(meeting_date, "EOW") do
    date = NaiveDateTime.to_date(meeting_date)
    day_of_week = Date.day_of_week(date)

    case(day_of_week) do
      x when x in 1..3 ->
        date |> Date.shift(day: 5 - day_of_week) |> NaiveDateTime.new!(~T[17:00:00])

      x when x in 4..5 ->
        date |> Date.shift(day: 7 - day_of_week) |> NaiveDateTime.new!(~T[20:00:00])
    end
  end

  def delivery_date(meeting_date, description) when is_binary(description) do
    cond do
      String.ends_with?(description, "M") ->
        value = description |> String.slice(0..-2//1) |> String.to_integer()

        meeting_date
        |> NaiveDateTime.to_date()
        |> then(fn date ->
          if meeting_date.month < value do
            Date.new!(date.year, value, 1)
          else
            Date.new!(date.year + 1, value, 1)
          end
        end)
        |> first_workday_of_month()
        |> NaiveDateTime.new!(~T[08:00:00])

      String.starts_with?(description, "Q") ->
        value = description |> String.slice(1..-1//1) |> String.to_integer()

        if Date.quarter_of_year(meeting_date) <= value do
          last_workday_of_quarter(meeting_date.year, value)
        else
          last_workday_of_quarter(meeting_date.year + 1, value)
        end
        |> NaiveDateTime.new!(~T[08:00:00])
    end
  end

  defp first_workday_of_month(date) do
    date = Date.beginning_of_month(date)

    case Date.day_of_week(date) do
      # Monday = 1, Friday = 5
      dow when dow in 1..5 ->
        date

      # Saturday
      6 ->
        Date.add(date, 2)

      # Sunday
      7 ->
        Date.add(date, 1)
    end
  end

  defp last_workday_of_quarter(year, quarter) when quarter in 1..4 do
    date = Date.new!(year, quarter * 3, 1) |> Date.end_of_month()

    case Date.day_of_week(date) do
      # Monday–Friday
      dow when dow in 1..5 ->
        date

      # Saturday → go back 1 day
      6 ->
        Date.add(date, -1)

      # Sunday → go back 2 days
      7 ->
        Date.add(date, -2)
    end
  end
end
