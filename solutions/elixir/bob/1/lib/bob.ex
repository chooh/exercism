defmodule Bob do
  def hey(input) do
    input = String.trim(input)
    question = String.last(input) == "?"
    yell = String.upcase(input) == input and String.match?(input, ~r/[[:upper:]]/u)
    cond do
      input == "" ->
        "Fine. Be that way!"
      yell and question ->
        "Calm down, I know what I'm doing!"
      question ->
        "Sure."
      yell ->
        "Whoa, chill out!"
      true -> "Whatever."
    end
  end
end
