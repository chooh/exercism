defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree([], []), do: {:ok, {}}

  def build_tree([a], [a]), do: {:ok, {{}, a, {}}}

  def build_tree(preorder, inorder) when length(preorder) != length(inorder),
    do: {:error, "traversals must have the same length"}

  def build_tree(preorder, inorder) do
    [root | rest] = preorder

    pos = Enum.find_index(inorder, &(&1 == root))

    cond do
      Enum.count(inorder, &(&1 == root)) > 1 ->
        {:error, "traversals must contain unique items"}

      pos == nil ->
        {:error, "traversals must have the same elements"}

      true ->
        {left_inorder, [^root | right_inorder]} = Enum.split(inorder, pos)

        {left_preorder, right_preorder} = Enum.split(rest, length(left_inorder))

        with {:ok, left} <- build_tree(left_preorder, left_inorder),
             {:ok, right} <- build_tree(right_preorder, right_inorder),
             do: {:ok, {left, root, right}}
    end
  end
end
