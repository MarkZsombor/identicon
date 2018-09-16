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
  end
  
  @doc """
    Converts a string into a list of numbers
  """
  
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end

end
