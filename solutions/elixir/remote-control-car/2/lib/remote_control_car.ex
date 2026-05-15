defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new(nickname \\ "none"), do: %__MODULE__{nickname: nickname}

  def display_distance(%__MODULE__{distance_driven_in_meters: distance}) do
    "#{distance} meters"
  end

  def display_battery(%__MODULE__{battery_percentage: percentage}) do
    if percentage == 0 do
      "Battery empty"
    else
      "Battery at #{percentage}%"
    end
  end

  def drive(%__MODULE__{battery_percentage: 0} = rc), do: rc

  def drive(%__MODULE__{battery_percentage: battery, distance_driven_in_meters: distance} = rc)
      when battery > 0,
      do: %{rc | battery_percentage: battery - 1, distance_driven_in_meters: distance + 20}
end
