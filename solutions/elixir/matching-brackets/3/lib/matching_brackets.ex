defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str), do: check_brackets(str, [])

  defp check_brackets(<<?[, str::binary>>, acc), do: check_brackets(str, [?] | acc])
  defp check_brackets(<<?], str::binary>>, [?] | rest]), do: check_brackets(str, rest)
  defp check_brackets(<<?{, str::binary>>, acc), do: check_brackets(str, [?} | acc])
  defp check_brackets(<<?}, str::binary>>, [?} | rest]), do: check_brackets(str, rest)
  defp check_brackets(<<?(, str::binary>>, acc), do: check_brackets(str, [?) | acc])
  defp check_brackets(<<?), str::binary>>, [?) | rest]), do: check_brackets(str, rest)

  defp check_brackets(<<symbol::utf8, str::binary>>, acc)
       when symbol not in [?], ?}, ?)],
       do: check_brackets(str, acc)

  defp check_brackets(<<>>, []), do: true
  defp check_brackets(_, _), do: false
end
