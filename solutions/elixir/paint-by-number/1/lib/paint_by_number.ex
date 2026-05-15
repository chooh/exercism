defmodule PaintByNumber do
  def palette_bit_size(color_count) do
    palette_bit_size(color_count, 1)
  end

  defp palette_bit_size(color_count, bits) do
    if Integer.pow(2, bits) >= color_count do
      bits
    else
      palette_bit_size(color_count, bits + 1)
    end
  end

  def empty_picture(), do: <<>>
  def test_picture(), do: <<0::2, 1::2, 2::2, 3::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bits = palette_bit_size(color_count)
    <<pixel_color_index::size(bits), picture::bitstring>>
  end

  def get_first_pixel(<<>>, _color_count), do: nil

  def get_first_pixel(picture, color_count) do
    bits = palette_bit_size(color_count)
    <<pixel::size(bits), _rest::bitstring>> = picture
    pixel
  end

  def drop_first_pixel(<<>>, _color_count), do: <<>>

  def drop_first_pixel(picture, color_count) do
    bits = palette_bit_size(color_count)
    <<_pixel::size(bits), rest::bitstring>> = picture
    rest
  end

  def concat_pictures(picture1, picture2) when is_bitstring(picture1) and is_bitstring(picture2),
    do: <<picture1::bitstring, picture2::bitstring>>
end
