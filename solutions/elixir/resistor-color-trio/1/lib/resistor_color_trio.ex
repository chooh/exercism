defmodule ResistorColorTrio do
  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label(colors) do
    number =
      colors
      |> Enum.take(2)
      |> Enum.map(&code/1)
      |> Integer.undigits()

    exp = colors |> Enum.at(2) |> code()

    number = number * Integer.pow(10, exp)

    cond do
      number >= 1_000_000_000 ->
        {div(number, 1_000_000_000), :gigaohms}

      number >= 1_000_000 ->
        {div(number, 1_000_000), :megaohms}

      number >= 1_000 ->
        {div(number, 1_000), :kiloohms}

      true ->
        {number, :ohms}
    end
  end

  defp code(color) do
    case color do
      :black -> 0
      :brown -> 1
      :red -> 2
      :orange -> 3
      :yellow -> 4
      :green -> 5
      :blue -> 6
      :violet -> 7
      :grey -> 8
      :white -> 9
    end
  end
end
