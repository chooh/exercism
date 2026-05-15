defmodule Matrix do
  defstruct [:numbers]

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    numbers =
      input
      |> String.split("\n")
      |> Enum.map(fn col ->
        col
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      end)

    %__MODULE__{numbers: numbers}
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    matrix.numbers
    |> Enum.map(fn col ->
      col
      |> Enum.map(&Kernel.to_string(&1))
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    matrix.numbers
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) when index > 0 do
    Matrix.rows(matrix) |> Enum.at(index - 1)
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
    matrix.numbers
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) when index > 0 do
    Matrix.columns(matrix) |> Enum.at(index - 1)
  end
end
