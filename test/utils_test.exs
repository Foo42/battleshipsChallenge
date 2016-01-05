defmodule Battleships.Utils.SnakecaseTests do
  use ExUnit.Case

  test "empty string" do
    assert Battleships.Utils.Snakecase.from_camel("") == ""
  end

  test "single word" do
    assert Battleships.Utils.Snakecase.from_camel("hello") == "hello"
  end

  test "multiple words" do
    assert Battleships.Utils.Snakecase.from_camel("AaBbCc") == "aa_bb_cc"
  end
end
