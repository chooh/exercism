defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    case String.split(path, ".") do
      [key] -> data[key]
      [key | rest] -> extract_from_path(data[key], Enum.join(rest, "."))
      _ -> nil
    end
  end

  def get_in_path(data, path) do
    get_in(data, String.split(path, "."))
  end
end
