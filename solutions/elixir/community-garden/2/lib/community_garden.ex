# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  defstruct next_id: 1, plots: []

  def start(opts \\ []) do
    Agent.start(fn -> %__MODULE__{} end, opts)
  end

  def list_registrations(pid), do: Agent.get(pid, __MODULE__, :do_list_registrations, [])

  def register(pid, register_to),
    do: Agent.get_and_update(pid, __MODULE__, :do_register, [register_to])

  def release(pid, plot_id), do: Agent.update(pid, __MODULE__, :do_release, [plot_id])

  def get_registration(pid, plot_id),
    do: Agent.get(pid, __MODULE__, :do_get_registration, [plot_id])

  def do_list_registrations(%__MODULE__{plots: plots}), do: plots

  def do_register(%__MODULE__{next_id: next_id, plots: plots} = state, register_to) do
    plot = %Plot{plot_id: next_id, registered_to: register_to}

    {plot, %{state | next_id: next_id + 1, plots: plots ++ [plot]}}
  end

  def do_release(%__MODULE__{plots: plots} = state, plot_id) do
    %{state | plots: Enum.reject(plots, fn plot -> plot.plot_id == plot_id end)}
  end

  def do_get_registration(%__MODULE__{plots: plots}, plot_id) do
    Enum.find(plots, {:not_found, "plot is unregistered"}, fn plot -> plot.plot_id == plot_id end)
  end
end
