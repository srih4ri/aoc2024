defmodule Solution do
  def read_input(file_name) do
    File.read(file_name)
  end

  def parse_map(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.with_index(fn line, row ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index(fn char, col ->
        {row, col, String.to_integer(char)}
      end)
    end)
    |> List.flatten()
  end

  def neighbor_positions() do
    [
      {-1, 0},
      {0, -1},
      {0, 1},
      {1, 0}
    ]
  end

  def find_valid_neighbors(_map, pos = {_, _, 9}) do
    [pos]
  end

  def find_valid_neighbors(map, {start_x, start_y, val}) do
    Enum.reduce(neighbor_positions(), [], fn {x, y}, acc ->
      n_pos = {start_x + x, start_y + y, val + 1}

      if Enum.member?(map, n_pos) do
        [n_pos | acc]
      else
        acc
      end
    end)
  end

  def find_start_positions(map) do
    map
    |> Enum.filter(fn {_row, _col, value} -> value == 0 end)
  end

  def count_trails(_, {_, _, 9}) do
    1
  end

  def count_trails(map, sp) do
    ns = find_valid_neighbors(map, sp)

    Enum.reduce(ns, 0, fn n_pos, acc ->
      acc + count_trails(map, n_pos)
    end)
  end

  def solution(:part_two, filename) do
    {:ok, content} = File.read(filename)
    map = parse_map(content)
    sps = find_start_positions(map)

    Enum.reduce(sps, 0, fn sp, paths ->
      paths + count_trails(map, sp)
    end)
  end
end

IO.inspect(Solution.solution(:part_two, "input_sample.txt"), label: "Part 2: Sample")
IO.inspect(Solution.solution(:part_two, "input.txt"), label: "Part 2: Actual")
