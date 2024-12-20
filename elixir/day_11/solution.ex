defmodule Solution do
  def read_input(file_name) do
    File.read(file_name)
  end

  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
    end)
    |> List.flatten()
  end

  def apply_rule("0" = _stone) do
    ["1"]
  end

  def apply_rule(stone) when is_bitstring(stone) and rem(byte_size(stone), 2) == 0 do
    stone
    |> String.split_at(div(byte_size(stone), 2))
    |> Tuple.to_list()
    |> Enum.map(fn x ->
      x |> String.to_integer() |> Integer.to_string()
    end)
  end

  def apply_rule(stone) when is_bitstring(stone) do
    r =
      stone
      |> String.to_integer()
      |> Kernel.*(2024)
      |> Integer.to_string()

    [r]
  end

  # def apply_rule(stones) when is_list(stones) or is_map(stones) do
  #   #  IO.inspect(stones, label: "Applying rule on")
  #   Enum.map(stones, &Solution.apply_rule/1)
  # end

  def iterate_stones(file_name, iter_count) do
    {:ok, content} = read_input(file_name)

    start = parse_input(content) |> Enum.frequencies()

    Enum.reduce(1..iter_count, start, fn _t, iteration_result ->
      Enum.reduce(iteration_result, %{}, fn {item, freq}, freq_count ->
        result = apply_rule(item)

        Enum.reduce(result, freq_count, fn item, acc ->
          if(Map.has_key?(acc, item)) do
            Map.put(acc, item, Map.get(acc, item) + freq)
          else
            Map.put(acc, item, freq)
          end
        end)
      end)
    end)
    |> Enum.reduce(0, fn {_item, freq}, acc ->
      freq + acc
    end)
  end

  def solution(:part_one, file_name) do
    iterate_stones(file_name, 25)
  end

  def solution(:part_two, file_name) do
    iterate_stones(file_name, 75)
  end
end

IO.inspect(Solution.solution(:part_one, "input_sample.txt"), label: "Part 1: Sample")
IO.inspect(Solution.solution(:part_one, "input.txt"), label: "Part 2: Actual")
IO.inspect(Solution.solution(:part_two, "input.txt"), label: "Part 2: Sample")
