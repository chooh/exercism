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

  def divide([0, _]), do: raise(DivisionByZeroError)
  def divide([a, b]), do: b / a
  def divide(_), do: raise(StackUnderflowError, "when dividing")
end
