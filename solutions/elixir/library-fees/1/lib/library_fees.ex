defmodule LibraryFees do
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime) do
    Time.compare(NaiveDateTime.to_time(datetime), ~T[12:00:00]) == :lt
  end

  def return_date(checkout_datetime) do
    days = if before_noon?(checkout_datetime), do: 28, else: 29
    checkout_datetime |> NaiveDateTime.to_date() |> Date.add(days)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    diff =
      actual_return_datetime
      |> NaiveDateTime.to_date()
      |> Date.diff(planned_return_date)

    if diff > 0, do: diff, else: 0
  end

  def monday?(datetime), do: Date.day_of_week(NaiveDateTime.to_date(datetime)) == 1

  def calculate_late_fee(checkout, return, rate) do
    checkout_dt = checkout |> datetime_from_string()
    return_dt = return |> datetime_from_string()
    fee = days_late(return_date(checkout_dt), return_dt) * rate
    if monday?(return_dt), do: trunc(fee / 2), else: fee
  end
end
