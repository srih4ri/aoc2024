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

  def path_exists?(map, start_pos, end_pos) do
    ns = find_valid_neighbors(map, start_pos)

    case ns do
      [fd = {_, _, 9}] ->
        fd == end_pos

      [] ->
        false

      _ ->
        Enum.any?(ns, fn n_pos ->
          new_start_positions = find_valid_neighbors(map, n_pos)

          Enum.any?(new_start_positions, fn new_pos ->
            path_exists?(map, new_pos, end_pos)
          end)
        end)
    end
  end

  def count_trails(map) do
    start_positions =
      map
      |> find_start_positions()

    end_positions =
      map
      |> find_end_positions()

    Enum.reduce(start_positions, 0, fn start_pos, total_paths ->
      valid_paths =
        Enum.reduce(end_positions, 0, fn end_pos, acc ->
          if path_exists?(map, start_pos, end_pos) do
            acc + 1
          else
            acc
          end
        end)

      total_paths + valid_paths
    end)
  end

  def solution(:part_one, :actual) do
    {:ok, content} = read_input("input.txt")

    content
    |> parse_map()
    |> count_trails()
  end

  def solution(:part_one, :sample) do
    {:ok, content} = read_input("input_sample.txt")
    map = parse_map(content)
    count_trails(map)
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

  def find_end_positions(map) do
    map
    |> Enum.filter(fn {_row, _col, value} -> value == 9 end)
  end
end

IO.inspect(Solution.solution(:part_one, :sample), label: "Part 1: Sample")
IO.inspect(Solution.solution(:part_one, :actual), label: "Part 1: Actual")
