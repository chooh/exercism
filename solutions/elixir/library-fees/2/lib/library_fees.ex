defmodule LibraryFees do
  @monday 1
  @noon ~T[12:00:00]

  @spec datetime_from_string(String.t()) :: NaiveDateTime.t()
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  @spec before_noon?(NaiveDateTime.t()) :: boolean()
  def before_noon?(datetime) do
    Time.compare(NaiveDateTime.to_time(datetime), @noon) == :lt
  end

  @spec return_date(NaiveDateTime.t()) :: Date.t()
  def return_date(checkout_datetime) do
    days = if before_noon?(checkout_datetime), do: 28, else: 29
    checkout_datetime |> NaiveDateTime.to_date() |> Date.add(days)
  end

  @spec days_late(Date.t(), NaiveDateTime.t()) :: integer()
  def days_late(planned_return_date, actual_return_datetime) do
    actual_return_datetime
    |> NaiveDateTime.to_date()
    |> Date.diff(planned_return_date)
    |> Kernel.max(0)
  end

  @spec monday?(NaiveDateTime.t()) :: boolean()
  def monday?(datetime), do: Date.day_of_week(NaiveDateTime.to_date(datetime)) == @monday

  @spec calculate_late_fee(String.t(), String.t(), pos_integer()) :: pos_integer()
  def calculate_late_fee(checkout, return, rate) do
    checkout_dt = checkout |> datetime_from_string()
    return_dt = return |> datetime_from_string()
    fee = days_late(return_date(checkout_dt), return_dt) * rate
    if monday?(return_dt), do: trunc(fee / 2), else: fee
  end
end
