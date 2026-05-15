defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(list), do: count(list, 0)

  defp count([], acc), do: acc
  defp count([_ | tail], acc), do: count(tail, acc + 1)

  @spec reverse(list) :: list
  def reverse(list), do: reverse(list, [])

  defp reverse([], acc), do: acc
  defp reverse([h | t], acc), do: reverse(t, [h | acc])

  @spec map(list, (any -> any)) :: list
  def map([], _), do: []
  def map([head | tail], f), do: [f.(head) | map(tail, f)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _), do: []
  def filter([h | t], f), do: if(f.(h), do: [h | filter(t, f)], else: filter(t, f))

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append([], b), do: b
  def append([h | t], b), do: [h | append(t, b)]

  @spec concat([[any]]) :: [any]
  def concat(ll), do: reduce(ll, [], &append(&2, &1))
end
