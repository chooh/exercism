defmodule TopSecret do
  def to_ast(string) do
    with {:ok, macro} <- Code.string_to_quoted(string) do
      macro
    end
  end

  def decode_secret_message_part(ast, acc) do
    with {op, _metadata, arguments} <- ast,
         true <- op == :def || op == :defp,
         secret <- decode_from_ast(hd(arguments)) do
      {ast, [secret | acc]}
    else
      _ -> {ast, acc}
    end
  end

  def decode_from_ast({:when, _, [ast | _]}), do: decode_from_ast(ast)
  def decode_from_ast({_op, _, nil}), do: ""
  def decode_from_ast({op, _, args}), do: op |> Atom.to_string() |> String.slice(0, length(args))

  def decode_secret_message(string) do
    {_ast, acc} = Macro.prewalk(to_ast(string), [], &decode_secret_message_part/2)

    acc |> Enum.reverse() |> Enum.join("")
  end
end
