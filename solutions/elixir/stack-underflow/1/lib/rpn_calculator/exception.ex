defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] ->
          %__MODULE__{}

        _ ->
          %__MODULE__{message: "stack underflow occurred, context: " <> value}
      end
    end
  end

  def divide([a,b]) do
    try do
      b / a
    rescue
      _ -> raise DivisionByZeroError
    end
  end
  def divide(_), do: raise StackUnderflowError, "when dividing"
end
