defmodule Tournament do
  @header "Team                           | MP |  W |  D |  L |  P"
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    data =
      input
      |> Enum.reduce([], fn entry, acc ->
        with [first, second, first_outcome] <- String.split(entry, ";"),
             true <- first_outcome in ["win", "loss", "draw"] do
          second_outcome =
            case first_outcome do
              "win" -> "loss"
              "loss" -> "win"
              "draw" -> "draw"
            end

          acc
          |> update(first, first_outcome)
          |> update(second, second_outcome)
        else
          _ -> acc
        end
      end)
      |> Enum.sort(fn a, b ->
        if elem(a, 5) == elem(b, 5) do
          elem(a, 0) < elem(b, 0)
        else
          elem(a, 5) >= elem(b, 5)
        end
      end)

    [
      @header
      | Enum.map(data, fn {name, mp, w, d, l, p} ->
          String.pad_trailing(name, 30) <>
            " | " <>
            String.pad_leading(to_string(mp), 2) <>
            " | " <>
            String.pad_leading(to_string(w), 2) <>
            " | " <>
            String.pad_leading(to_string(d), 2) <>
            " | " <>
            String.pad_leading(to_string(l), 2) <>
            " | " <>
            String.pad_leading(to_string(p), 2)
        end)
    ]
    |> Enum.join("\n")
  end

  defp update(list, name, outcome) do
    {_, mp, w, d, l, p} = List.keyfind(list, name, 0, {name, 0, 0, 0, 0, 0})

    new =
      case outcome do
        "win" -> {name, mp + 1, w + 1, d, l, p + 3}
        "loss" -> {name, mp + 1, w, d, l + 1, p}
        "draw" -> {name, mp + 1, w, d + 1, l, p + 1}
      end

    List.keystore(list, name, 0, new)
  end
end
