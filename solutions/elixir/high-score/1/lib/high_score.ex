defmodule HighScore do
  def new(), do: %{}

  def add_player(scores, name, score \\ 0) do
    scores |> Map.put(name, score)
  end

  def remove_player(scores, name) do
    scores |> Map.delete(name)
  end

  def reset_score(scores, name), do: add_player(scores, name)

  def update_score(scores, name, score) do
    {_, map} = Map.get_and_update(scores, name, fn x ->
      {x, (x || 0) + score}
    end)
    map
  end

  def get_players(scores) do
    scores |> Map.keys()
  end
end
