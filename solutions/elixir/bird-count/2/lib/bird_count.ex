defmodule BirdCount do
  def today([]), do: nil
  def today([today | _]), do: today

  def increment_day_count([]), do: [1]
  def increment_day_count([today | rest]), do: [today + 1 | rest]

  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([today | rest]) do
    case today do
      0 -> true
      _ -> has_day_without_birds?(rest)
    end
  end

  def total([]), do: 0
  def total([h|t]), do: h + total(t)

  def busy_days([]), do: 0
  def busy_days([h|t]) do
    if h >= 5 do
      1 + busy_days(t)
    else
      busy_days(t)
    end
  end
end
