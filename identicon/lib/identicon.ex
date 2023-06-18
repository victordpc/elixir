defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_imput
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  defp save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  defp draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
end

  defp build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      grid
      |> Enum.map(fn {_code, index} ->
        {
          {rem(index, 5) * 50, div(index, 5) * 50},
          {rem(index, 5) * 50 + 50, div(index, 5) * 50 + 50}
        }
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  defp filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {code, _index} -> rem(code, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

  defp build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  defp mirror_row(row) do
    [first, second | _] = row
    row ++ [second, first]
  end

  defp pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  defp hash_imput(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
