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
    case list do
      [] -> nil
      [head|_] -> head
    end
  end

  def count(list) do
    length(list)
  end

  def functional_list?(list) do
    Enum.member?(list, "Elixir")
  end
end
