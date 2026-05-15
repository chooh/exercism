defmodule SplitSecondStopwatch do
  @doc """
  A stopwatch that can be used to track lap times.
  """

  @type state :: :ready | :running | :stopped

  defmodule Stopwatch do
    @type t :: %__MODULE__{
            state: SplitSecondStopwatch.state(),
            previous_laps: [Time.t()],
            current_lap: Time.t(),
            total: Time.t()
          }
    defstruct state: :ready,
              previous_laps: [],
              current_lap: ~T[00:00:00],
              total: ~T[00:00:00]
  end

  @spec new() :: Stopwatch.t()
  def new() do
    %Stopwatch{}
  end

  @spec state(Stopwatch.t()) :: state()
  def state(%Stopwatch{state: state}), do: state

  @spec current_lap(Stopwatch.t()) :: Time.t()
  def current_lap(%Stopwatch{current_lap: current_lap}), do: current_lap

  @spec previous_laps(Stopwatch.t()) :: [Time.t()]
  def previous_laps(%Stopwatch{previous_laps: previous_laps}), do: previous_laps

  @spec advance_time(Stopwatch.t(), Time.t()) :: Stopwatch.t()
  def advance_time(%Stopwatch{state: :running} = stopwatch, time) do
    {seconds, _} = Time.to_seconds_after_midnight(time)

    stopwatch
    |> Map.update!(:total, &Time.add(&1, seconds, :second))
    |> Map.update!(:current_lap, &Time.add(&1, seconds, :second))
  end

  def advance_time(stopwatch, _time), do: stopwatch

  @spec total(Stopwatch.t()) :: Time.t()
  def total(%Stopwatch{total: total}), do: total

  @spec start(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def start(%Stopwatch{state: :running}),
    do: {:error, "cannot start an already running stopwatch"}

  def start(%Stopwatch{} = stopwatch), do: %{stopwatch | state: :running}

  @spec stop(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def stop(%Stopwatch{state: :running} = stopwatch), do: %{stopwatch | state: :stopped}
  def stop(_stopwatch), do: {:error, "cannot stop a stopwatch that is not running"}

  @spec lap(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def lap(%Stopwatch{state: :running} = stopwatch) do
    %{
      stopwatch
      | previous_laps: stopwatch.previous_laps ++ [stopwatch.current_lap],
        current_lap: ~T[00:00:00]
    }
  end

  def lap(_stopwatch), do: {:error, "cannot lap a stopwatch that is not running"}

  @spec reset(Stopwatch.t()) :: Stopwatch.t() | {:error, String.t()}
  def reset(%Stopwatch{state: :stopped}), do: new()
  def reset(_stopwatch), do: {:error, "cannot reset a stopwatch that is not stopped"}
end
