class Solution
  def initialize(file)
    @map = File.readlines(file).map(&:chomp).map(&:chars).map { |row| row.map { |cell| cell.to_i } }
  end

  def find_neighbours(cell)
    # Method to find the neighbours of a cell
    # Neighbours are cells that are adjacent to the current cell
    # and are not the current cell
    x = cell[0]
    y = cell[1]
    curr = @map[x][y]
    -1.upto(1).flat_map do |row_offset|
      -1.upto(1).map do |col_offset|
        next if row_offset < 0 || col_offset < 0
        if @map[x + row_offset]         
          if @map[x + row_offset][y + col_offset]
            n_value = @map[x + row_offset][y + col_offset]
            puts "#{x + row_offset}, #{y + col_offset} = #{n_value}"
            puts "n_value - curr = #{n_value - curr}"
            if n_value - curr == 1 
              puts "Found valid path from #{cell} to #{[x + row_offset, y + col_offset]}"
              [x + row_offset, y + col_offset]
            end
          end
        end
      end.compact
    end.compact
  end

  def path_exists?(start, finish)
    # Method to check if a path exists from start to finish
    # where next valid step is current cell + 1
    # and the next cell is adjacent to the current cell
    # and the next cell is not a wall (1)
    # (i.e. the current cell + 1)
    current_cell = start
    current_cell_value = @map[current_cell[0]][current_cell[1]]
    puts "Current cell val: #{current_cell_value.inspect}"
    ns = find_neighbours(current_cell)
    puts "Neighbours: #{ns.inspect}"
    ns.each do |neighbour|
      puts "Neighbour: #{neighbour.inspect}"
    end
    exit
  end

  def calculate_score(trailhead)
    possible_trailends.count do |trailend|
      puts "\t Checking path from #{trailhead} to #{trailend}"
      path_exists?(trailhead, trailend)
    end
  end

  def solution_1
    puts `cat input_sample.txt`
    possible_trailheads.sum do |trailhead|
      puts "Calculating score for #{trailhead}"
      s = calculate_score(trailhead)
      puts "Score: #{s}"
      s
    end
  end

  def possible_trailheads
    t = []
    @map.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        if cell == 0
          t << [row_index, col_index]
        end
      end
    end
    t
  end

  def possible_trailends
    t = []
    @map.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        if cell == 9
          t << [row_index, col_index]
        end
      end
    end
    t
  end

  def solution_2
  end
end
