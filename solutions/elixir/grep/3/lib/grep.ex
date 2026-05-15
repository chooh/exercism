defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    flagz = %{
      n: "-n" in flags,
      l: "-l" in flags,
      i: "-i" in flags,
      v: "-v" in flags,
      x: "-x" in flags,
      m: length(files) > 1
    }

    re_flags = if flagz.i, do: "i", else: ""
    re_pattern = if flagz.x, do: "^#{pattern}$", else: pattern

    regex = Regex.compile!(re_pattern, re_flags)

    filename_only =
      if "-l" in flags do
        fn
          [], _file -> []
          _, file -> [file, "\n"]
        end
      else
        fn d, _file -> d end
      end

    Enum.map(files, fn file ->
      grep_file(regex, flagz, file)
      |> then(fn d -> filename_only.(d, file) end)
    end)
    |> IO.iodata_to_binary()
  end

  defp grep_file(regex, flagz, file) do
    mapper =
      cond do
        flagz.n and flagz.m ->
          fn {file, line, str, _} -> [file, ":", to_string(line), ":", str] end

        flagz.n ->
          fn {_file, line, str, _} -> [to_string(line), ":", str] end

        flagz.m ->
          fn {file, _line, str, _} -> [file, ":", str] end

        true ->
          fn {_file, _line, str, _} -> str end
      end

    File.stream!(file)
    |> Enum.with_index(fn str, index -> {file, index + 1, str, Regex.match?(regex, str)} end)
    |> Enum.filter(fn {_, _, _, m} -> (m and not flagz.v) or (not m and flagz.v) end)
    |> Enum.map(mapper)
  end
end
