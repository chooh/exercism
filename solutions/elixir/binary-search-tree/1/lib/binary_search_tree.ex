defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(tree = %{data: d, left: l, right: r}, data) do
    cond do
      data > d ->
        %{tree | right: if(is_nil(r), do: new(data), else: insert(r, data))}

      data <= d ->
        %{tree | left: if(is_nil(l), do: new(data), else: insert(l, data))}
    end
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(nil), do: []
  def in_order(%{data: d, left: l, right: r}), do: in_order(l) ++ [d] ++ in_order(r)
end
