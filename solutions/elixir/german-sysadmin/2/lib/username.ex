defmodule Username do
  def sanitize(username) do
    # ä becomes ae
    # ö becomes oe
    # ü becomes ue
    # ß becomes ss
    username
    |> Enum.flat_map(fn ch ->
      case ch do
        ch when ch in ?a..?z -> [ch]
        ?_ -> [ch]
        ?ä -> 'ae'
        ?ö -> 'oe'
        ?ü -> 'ue'
        ?ß -> 'ss'
        _ -> []
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
