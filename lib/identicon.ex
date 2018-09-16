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
end
