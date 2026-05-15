defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    {nil}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem) do
    {elem, list}
  end

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count(list), do: do_count(list, 0)

  defp do_count({nil}, counter), do: counter
  defp do_count({_, list}, counter), do: do_count(list, counter + 1)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?({nil}), do: true
  def empty?(_), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({elem, _}), do: {:ok, elem}
  def peek({nil}), do: {:error, :empty_list}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({_, list}), do: {:ok, list}
  def tail({nil}), do: {:error, :empty_list}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({elem, list}), do: {:ok, elem, list}
  def pop({nil}), do: {:error, :empty_list}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: List.foldr(list, new(), &push(&2, &1))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: do_to_list(list, [])

  defp do_to_list({nil}, acc), do: acc
  defp do_to_list({elem, tail}, acc), do: do_to_list(tail, acc ++ [elem])

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: do_reverse(list, new())

  defp do_reverse({nil}, to), do: to
  defp do_reverse({elem, rest}, to), do: do_reverse(rest, {elem, to})
end
