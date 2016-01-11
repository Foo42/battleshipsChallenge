defmodule Battleships.Utils.Snakecase do
  def from_camel(s) do
    s
    |> String.graphemes
    |> Enum.reduce([], &process_character/2)
    |> Enum.reverse
    |> Enum.map(&String.downcase(&1))
    |> Enum.join("_")
  end

  defp process_character(char, acc) do
    if is_new_word?(char, acc) do
      add_new_word(char, acc)
    else
      add_to_word(char, acc)
    end
  end

  defp is_new_word?(char, [current | _previous]), do: is_capital? char
  defp is_new_word?(char, []), do: true
  defp is_capital?(char), do: ~r{[A-Z]} |> Regex.match?(char)

  defp add_new_word(char, []), do: [char]
  defp add_new_word(char, acc), do: [char] ++ acc
  defp add_to_word(char, [current | previous]), do: [current <> char] ++ previous
end