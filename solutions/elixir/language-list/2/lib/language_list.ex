defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove(list) do
    case list do
      [] -> []
      [_|tail] -> tail
    end
  end

  def first(list) do
    list |> List.first()
  end

  def count(list) do
    length(list)
  end

  def functional_list?(list) do
    case list do
      [] -> false
      [head|tail] -> head == "Elixir" || functional_list?(tail)
    end
  end
end
