defmodule RPNCalculatorInspection do
  @timeout 100
  def start_reliability_check(calculator, input) do
    {:ok, pid} = Task.start_link(fn -> calculator.(input) end)
    %{input: input, pid: pid}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _reason} -> Map.put(results, input, :error)
    after
      @timeout -> Map.put(results, input, :timeout)
    end
  end

  def reliability_check(calculator, inputs) do
    trap_exit = Process.flag(:trap_exit, true)

    output =
      inputs
      |> Enum.map(fn input -> start_reliability_check(calculator, input) end)
      |> Enum.reduce(%{}, &await_reliability_check_result/2)

    Process.flag(:trap_exit, trap_exit)

    output
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1) end))
    |> Task.await_many(@timeout)
  end
end
