defmodule Solution do
  def read_input(file_name) do
    File.read(file_name)
  end

  def parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.with_index(fn line, row ->
      line
      |> String.split(" ")
    end)
    |> List.flatten()
  end

  def apply_rule("0" = stone) do
    "1"
  end

  def apply_rule(stone) when is_bitstring(stone) and rem(byte_size(stone), 2) == 0 do
    # IO.inspect(stone, label: "Applying on string with even byte size")
    stone
    |> String.split_at(div(byte_size(stone), 2))
    |> Tuple.to_list()
    |> Enum.map(fn x ->
      x |> String.to_integer() |> Integer.to_string()
    end)
  end

  def apply_rule(stone) when is_bitstring(stone) do
    # IO.inspect(stone, label: "Applying on string")
    stone
    |> String.to_integer()
    |> Kernel.*(2024)
    |> Integer.to_string()
  end

  def apply_rule(stones) when is_list(stones) or is_map(stones) do
    #  IO.inspect(stones, label: "Applying rule on")
    Enum.map(stones, &Solution.apply_rule/1)
  end

  def iterate_stones(file_name, iter_count) do
    {:ok, content} = read_input(file_name)

    parse_input(content)
    |> Enum.map(fn stone ->
      IO.inspect(stone, label: "Processing")

      s =
        Enum.reduce(1..iter_count, [stone], fn x, acc ->
          IO.inspect(x)
          List.flatten(apply_rule(acc))
        end)
    end)
    |> Enum.reduce(0, fn x, acc ->
      IO.inspect(x, label: "Lenght")
      IO.inspect(Enum.count(x), label: "Lenght")
      acc + Enum.count(x)
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
IO.inspect(Solution.solution(:part_one, "input.txt"), label: "Part 1: Sample")
IO.inspect(Solution.solution(:part_two, "input.txt"), label: "Part 1: Sample")
# IO.inspect(Solution.solution(:part_one, :actual), label: "Part 1: Actual")
