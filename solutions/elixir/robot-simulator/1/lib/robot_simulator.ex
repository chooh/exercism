defmodule RobotSimulator do
  @type direction :: :north | :east | :south | :west

  defstruct direction: :north, position: {0, 0}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    cond do
      direction not in [:north, :east, :south, :west] ->
        {:error, "invalid direction"}

      not match?({x, y} when is_integer(x) and is_integer(y), position) ->
        {:error, "invalid position"}

      true ->
        %RobotSimulator{direction: direction, position: position}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(
        %RobotSimulator{direction: direction, position: {x, y} = position},
        <<head, rest::binary>>
      ) do
    case head do
      ?R ->
        case direction do
          :north -> %RobotSimulator{direction: :east, position: position}
          :east -> %RobotSimulator{direction: :south, position: position}
          :south -> %RobotSimulator{direction: :west, position: position}
          :west -> %RobotSimulator{direction: :north, position: position}
        end
      ?L ->
        case direction do
          :north -> %RobotSimulator{direction: :west, position: position}
          :west -> %RobotSimulator{direction: :south, position: position}
          :south -> %RobotSimulator{direction: :east, position: position}
          :east -> %RobotSimulator{direction: :north, position: position}
        end
      ?A ->
        case direction do
          :north -> %RobotSimulator{direction: direction, position: {x, y + 1}}
          :east -> %RobotSimulator{direction: direction, position: {x + 1, y}}
          :south -> %RobotSimulator{direction: direction, position: {x, y - 1}}
          :west -> %RobotSimulator{direction: direction, position: {x - 1, y}}
        end
      _ ->
        {:error, "invalid instruction"}
    end
    |> simulate(rest)
  end
  def simulate(robot, _), do: robot

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end
end
