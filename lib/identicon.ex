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

end
