defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()

  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map(&translate_word/1)
    |> Enum.join(" ")
  end

  def translate_word(word) do
    {head, tail} = split(word)
    head <> tail <> "ay"
  end

  def split(word, cons \\ "") do
    case word do
      # Some groups are treated like vowels, including "yt" and "xr".
      <<"yt"::utf8, _::binary>> -> {word, ""}
      <<"yd"::utf8, _::binary>> -> {word, ""}
      <<"xr"::utf8, _::binary>> -> {word, ""}
      <<"xb"::utf8, _::binary>> -> {word, ""}

      # Some groups of letters are treated like consonants, including "qu"
      <<"qu"::utf8, rest::binary>> -> split(rest, cons <> "qu")

      <<letter::utf8, _rest::binary>> when letter in 'aeiou' -> {word, cons}
      <<letter::utf8, rest::binary>> -> split(rest, cons <> <<letter>>)

      _ -> {"", cons}
    end
  end
end
