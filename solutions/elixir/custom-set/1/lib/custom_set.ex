defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}
  defstruct map: []

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    %__MODULE__{map: enumerable |> Enum.uniq()}
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    custom_set.map == []
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    Enum.member?(custom_set.map, element)
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    Enum.all?(custom_set_1.map, fn el -> contains?(custom_set_2, el) end)
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    intersection(custom_set_1, custom_set_2) |> empty?() and
      intersection(custom_set_2, custom_set_1) |> empty?()
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    subset?(custom_set_1, custom_set_2) && subset?(custom_set_2, custom_set_1)
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    new([element | custom_set.map])
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    new(Enum.filter(custom_set_1.map, fn el -> contains?(custom_set_2, el) end))
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    new(Enum.reject(custom_set_1.map, fn el -> contains?(custom_set_2, el) end))
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    new(custom_set_1.map ++ custom_set_2.map)
  end
end
