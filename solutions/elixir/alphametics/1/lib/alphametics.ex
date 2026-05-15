defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    rows = puzzle |> String.split(~r/\s(\+|==)\s/) |> Enum.map(&String.to_charlist/1)

    non_zero = Enum.map(rows, &Kernel.hd/1) |> Enum.uniq()

    max_len = rows |> Enum.map(&Kernel.length/1) |> Enum.max()

    columns =
      rows
      |> Enum.map(fn row -> List.duplicate(?\s, max_len - length(row)) ++ row end)
      |> Enum.zip_with(&Function.identity/1)
      |> Enum.reverse()

    chars = columns |> List.flatten() |> Enum.reject(&(&1 == ?\s)) |> Enum.uniq()

    assign(chars, %{}, non_zero) |> Enum.find(fn a -> columns_ok?(columns, a) end)
  end

  defp assign([], assignment, _non_zero), do: [assignment]

  defp assign([l | rest], assignment, non_zero) do
    used = Map.values(assignment) |> MapSet.new()

    for d <- 0..9,
        d not in used,
        not (d == 0 and l in non_zero),
        new_assignment = Map.put(assignment, l, d),
        res <- assign(rest, new_assignment, non_zero) do
      res
    end
  end

  defp columns_ok?(columns, assignment) do
    check_columns(columns, assignment, 0)
  end

  defp check_columns([], _assignment, carry) do
    # в конце перенос должен быть 0
    carry == 0
  end

  defp check_columns([column | rest], assignment, carry_in) do
    {adds, [res]} = Enum.split(column, -1)

    add_digits =
      for l <- adds, Map.has_key?(assignment, l), do: assignment[l]

    known_sum = Enum.sum(add_digits) + carry_in

    res_digit = assignment[res]

    rem(known_sum, 10) == res_digit and check_columns(rest, assignment, div(known_sum, 10))
  end
end
