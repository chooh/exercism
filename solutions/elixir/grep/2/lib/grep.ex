defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    re_flags = if "-i" in flags, do: "i", else: ""

    re_pattern =
      if "-x" in flags do
        "\\A" <> pattern <> "\\z"
      else
        pattern
      end

    regex = Regex.compile!(re_pattern, re_flags)

    prepend_filename =
      if length(files) > 1 do
        fn d, file -> [file, ":", d] end
      else
        fn d, _ -> d end
      end

    filename_only =
      if "-l" in flags do
        fn
          [], _ -> []
          _, file -> [file, "\n"]
        end
      else
        fn d, _ -> d end
      end

    files
    |> Enum.map(fn file ->
      grep_file(regex, flags, file)
      |> Enum.reject(fn x -> x == [] end)
      |> Enum.map(fn d -> prepend_filename.(d, file) end)
      |> then(fn d -> filename_only.(d, file) end)
    end)
    |> IO.iodata_to_binary()
  end

  defp grep_file(regex, flags, file) do
    matcher =
      if "-v" in flags do
        fn {str, _} -> !String.match?(str, regex) end
      else
        fn {str, _} -> String.match?(str, regex) end
      end

    mapper =
      if "-n" in flags do
        fn {str, line} -> [to_string(line), ":", str] end
      else
        fn {str, _} -> str end
      end

    with {:ok, content} <- File.read(file) do
      content
      |> String.split("\n")
      |> Enum.with_index(1)
      |> Enum.filter(matcher)
      |> Enum.map(mapper)
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.map(fn
        [] -> []
        x -> [x, "\n"]
      end)
    end
  end
end
