defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: inventory |> Enum.sort_by(&(&1.price))

  def with_missing_price(inventory), do: inventory |> Enum.filter(&is_nil(&1.price))

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      Map.update(item, :name, nil, fn name -> String.replace(name, old_word, new_word) end)
    end)
  end

  def increase_quantity(item, count) do
    Map.update(item, :quantity_by_size, %{}, fn stock ->
      Enum.into(stock, %{}, fn {size, quantity} -> {size, quantity + count} end)
    end)
  end

  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_size, quantity}, acc -> acc + quantity end)
  end
end
