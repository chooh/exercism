defmodule RPNCalculator do
  def calculate!(stack, operation) do
    operation.(stack)
  end

  def calculate(stack, operation) do
    case rv = calculate_verbose(stack, operation) do
      {:ok, _} -> rv
      {:error, _} -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      rv = calculate!(stack, operation)
      {:ok, rv}
    rescue
      e -> {:error, e.message}
    end
  end
end
