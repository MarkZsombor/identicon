defmodule Identicon do
  @moduledoc """
  Creates an Identicon (a 5x5 image file) based on a string input.
  """

  @doc """
    Responsible for chaining the needed functions
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end
  
  @doc """
    Converts a string into a list of numbers
  """
  
  def hash_input(input) do
    seed = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{seed: seed}
  end

  @doc """
    Determins a RGB color from the first three values of a struct input
  """

  # Pattern matching can be done in the argument of the function
  def pick_color(%Identicon.Image{seed: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Determines a grid of values based on a struct input
  """

  def build_grid(%Identicon.Image{seed: seed} = image) do
    grid = 
      seed
      # Breaks list into list of lists length 3
      |> Enum.chunk_every(3, 3, :discard)
      # to feed function into map need the &fn/arity
      |> Enum.map(&mirror_list/1)
      # Turns the list of lists into a single list
      |> List.flatten
      # Adds index to the list for referencing
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    takes a list of 3 and returns a new list of 5 that has been mirrored
  """

  def mirror_list(list) do
    [a , b | _] = list

    list ++ [b, a]
  end

  @doc """
    Filters out items from a list with an odd value
  """

  def filter_odd(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _i}) -> 
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Generates the coords for a 5x5 grid image based on list of tuples
  """

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_coords = Enum.map grid, fn({_, index}) ->
      # Calculate the top right and bottom right corners for a 50x50 pix square
      hor = rem(index, 5) * 50
      vert = div(index, 5) * 50

      top_left = {hor, vert}
      bottom_right = {hor + 50, vert + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_coords: pixel_coords}
  end

  @doc """
    Creates an image
  """

  def draw_image(%Identicon.Image{color: color, pixel_coords: pixel_coords}) do
    # Use the erlang EGD module
    # http://erlang.org/documentation/doc-6.1/lib/percept-0.8.9/doc/html/egd.html
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_coords, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  @doc """
    Saves image to file
  """

  def save_image(image, filename) do 
    File.write("#{filename}.png", image)
  end
end
