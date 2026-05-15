defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """
  def new, do: %{}

  def roster(db) do
    db
      |> Map.keys()
      |> Enum.sort() 
      |> Enum.map(fn key -> Map.get(db, key) |> Enum.sort() end)
      |> List.flatten()
  end

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t(), integer) :: map
  def add(db, name, grade) do
    if Enum.member?(roster(db), name) do
      {:error, db}
    else
      {:ok, Map.update(db, grade, [name], fn students -> [name | students] end)}
    end
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t()]
  def grade(db, grade) do
    Map.get(db, grade, []) |> Enum.sort()
  end
end