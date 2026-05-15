defmodule Garden do
  @default_student_names [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]

  @plants %{
    "C" => :clover,
    "G" => :grass,
    "R" => :radishes,
    "V" => :violets
  }

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_student_names) do
    [first_row, second_row] =
      Enum.map(String.split(info_string, "\n"), fn row ->
        row
        |> String.pad_trailing(length(student_names) * 2)
        |> String.codepoints()
        |> Stream.chunk_every(2)
      end)

    Stream.zip([first_row, second_row, Enum.sort(student_names)])
    |> Enum.into(%{}, fn
      {[" ", " "], [" ", " "], name} -> {name, {}}
      {[a, b], [c, d], name} -> {name, {@plants[a], @plants[b], @plants[c], @plants[d]}}
    end)
  end
end
