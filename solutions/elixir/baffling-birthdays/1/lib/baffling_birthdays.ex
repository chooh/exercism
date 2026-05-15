defmodule BafflingBirthdays do
  @moduledoc """
  Estimate the probability of shared birthdays in a group of people.
  """
  @num_samples 100_000

  @spec shared_birthday?(birthdates :: [Date.t()]) :: boolean()
  def shared_birthday?([]), do: false

  def shared_birthday?([head | tail]) do
    Enum.any?(tail, fn x -> x.month == head.month && x.day == head.day end) ||
      shared_birthday?(tail)
  end

  @spec random_birthdates(group_size :: integer()) :: [Date.t()]
  def random_birthdates(group_size) do
    today = Date.utc_today()

    Stream.repeatedly(&:rand.uniform/0)
    |> Stream.map(fn x -> Date.add(today, -1 * round(x * 80 * 365)) end)
    |> Stream.reject(&Date.leap_year?/1)
    |> Stream.take(group_size)
    |> Enum.to_list()
  end

  @spec estimated_probability_of_shared_birthday(group_size :: integer()) :: float()
  def estimated_probability_of_shared_birthday(group_size) do
    1..@num_samples
    |> Enum.reduce(0, fn _i, acc ->
      if shared_birthday?(random_birthdates(group_size)) do
        acc + 1
      else
        acc
      end
    end)
    |> then(fn total -> 100 * total / @num_samples end)
  end
end
