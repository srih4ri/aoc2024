
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
        #IO.puts "--->>>>>>"
        ns = find_valid_neighbors(map, start_pos)

        # ##IOpect start_pos, label: "Pointer"
        # ##IOpect ns, label: "Neighbors"
        # ##IOpect end_pos, label: "End"
        
        
        sp = case ns do
            [fd = {_,_,9}] ->
                ##IOpect fd == end_pos, label: "Found end"
                fd == end_pos
            [] -> 
                ###IOpect "No neighbors"
                false
            _ -> 
                
                Enum.any?(ns, fn n_pos -> 
                    #IOpect n_pos, label: "\tChecking neighbors"
                    new_start_positions = find_valid_neighbors(map, n_pos)
                    # ##IOpect new_start_positions, label: "New start positions"
                    Enum.any?(new_start_positions, fn new_pos-> 
                        #IOpect new_pos, label: "\tChecking if neighbor have a path"
                        path_exists?(map, new_pos, end_pos)
                        
                    end)
                end)
        end
    end

    def count_trails(map) do
            start_positions = map 
        |> find_start_positions()
        
        end_positions = map
        |> find_end_positions()
        
        Enum.reduce(start_positions, 0, fn start_pos, total_paths -> 

            #IOpect start_pos,label: "\n\n\nStart position"
            #IOpect total_paths, label: "Total paths"
            valid_paths = Enum.reduce(end_positions, 0, fn end_pos, acc ->     
                 if a = path_exists?(map, start_pos, end_pos) do 
                    #IOpect end_pos, label: "Path exists"
                    acc + 1
                else 
                    ##IOpect "No ound path"
                    acc
                end                
            end)
            #IOpect valid_paths, label: "Valid paths"
            total_paths + valid_paths
        end)
    end
    def solution(:part_one, :actual) do 
        {:ok, content} = read_input("input.txt")
        map = parse_map(content)
        count_trails(map)
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
    
    def find_trail_ends(map, start_pos = {start_x, start_y, val}) do
        positions = find_valid_neighbors(map, {start_x, start_y, val})
        if positions == [] do
            []
        else
            positions
        end
    end
    
    def find_valid_neighbors(map, pos =  {start_x, start_y, 9}) do
        [pos]
    end

    def find_valid_neighbors(map, start_pos = {start_x, start_y, val}) do
        Enum.reduce(neighbor_positions(),[], fn {x,y},acc -> 
            n_pos = {start_x + x, start_y + y, val + 1}
            if Enum.member?(map, n_pos) do
                [ n_pos | acc]
            else
                acc
            end           
        end)
    end

        
    def find_start_positions(map) do
        Enum.filter(map, fn {_row, _col, value} -> value == 0 end)
    end

    def find_end_positions(map) do
        Enum.filter(map, fn {_row, _col, value} -> value == 9 end)
    end
end

IO.inspect Solution.solution(:part_one, :sample), label: "Part 1: Sample"
IO.inspect Solution.solution(:part_one, :actual), label: "Part 1: Actual"