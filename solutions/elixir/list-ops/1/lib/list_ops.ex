defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(list), do: count(list, 0)

  def count([], acc), do: acc

  def count([head | tail], acc) do
    count(tail, acc + 1)
  end

  @spec reverse(list) :: list
  def reverse(list), do: reverse(list, [])

  def reverse([], acc), do: acc

  def reverse([h | t], acc) do
    reverse(t, [h | acc])
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: map(l, f, [])

  def map([], f, acc), do: reverse(acc)

  def map([head | tail], f, acc) do
    map(tail, f, [f.(head) | acc])
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter(l, f, [])

  def filter([], _, acc), do: reverse(acc)
  def filter([h | t], f, acc), do: filter(t, f, if(f.(h), do: [h | acc], else: acc))

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc
  def reduce([h | t], acc, f), do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: appendr(reverse(a), b)
  def appendr([], b), do: b
  def appendr([h|t], b), do: appendr(t, [h|b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: reduce(ll, [], &(append(&2, &1)))
end
