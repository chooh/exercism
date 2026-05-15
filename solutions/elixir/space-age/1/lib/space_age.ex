defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(:earth, s), do: s / 31_557_600

  def age_on(planet, s) do
    f =
      case planet do
        :mercury -> 0.2408467
        :venus -> 0.61519726
        :mars -> 1.8808158
        :jupiter -> 11.862615
        :saturn -> 29.447498
        :uranus -> 84.016846
        :neptune -> 164.79132
      end

    age_on(:earth, s) / f
  end
end
