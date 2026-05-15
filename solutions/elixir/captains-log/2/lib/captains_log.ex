defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  @min_stardate 41000.0
  @max_stardate 42000.0

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    "NCC-#{Enum.random(1000..9999)}"
  end

  def random_stardate() do
    @min_stardate + :rand.uniform() * (@max_stardate - @min_stardate)
  end

  def format_stardate(stardate) when is_float(stardate) do
    :io_lib.format("~.1f", [stardate]) |> List.to_string()
  end

  def format_stardate(_) do
    raise ArgumentError, message: "the argument value is invalid"
  end
end
