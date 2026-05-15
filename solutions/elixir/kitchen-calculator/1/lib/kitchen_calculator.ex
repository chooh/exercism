defmodule KitchenCalculator do
  def get_volume({_, value}), do: value

  def to_milliliter({unit, value}) do
    case unit do
      :milliliter -> {:milliliter, value}
      :cup -> {:milliliter, value * 240}
      :fluid_ounce -> {:milliliter, value * 30}
      :teaspoon -> {:milliliter, value * 5}
      :tablespoon -> {:milliliter, value * 15}
    end
  end

  def from_milliliter({:milliliter, value}, unit) do
    case unit do
      :milliliter -> {:milliliter, value}
      :cup -> {:cup, value / 240}
      :fluid_ounce -> {:fluid_ounce, value / 30}
      :teaspoon -> {:teaspoon, value / 5}
      :tablespoon -> {:tablespoon, value / 15}
    end
  end

  def convert(volume_pair, unit) do
    volume_pair |> to_milliliter() |> from_milliliter(unit)
  end
end
