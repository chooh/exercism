defmodule NameBadge do
  def print(id, name, department) do
    [
      if(id, do: "[#{id}]", else: nil),
      name,
      String.upcase(department || "owner")
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" - ")
  end
end
