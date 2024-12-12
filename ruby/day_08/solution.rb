class Solution
  attr_reader :antenna_positions, :length, :breadth, :antinodes

  def initialize(input_file)
    @antenna_positions = {}
    length = 0
    breadth = 0
    File.readlines(input_file).each_with_index do |line, x|
      length += 1
      breadth = line.chomp.length
      line.chomp.chars.each_with_index do |char, y|
        if char == "."
          # puts "Blank at #{x},#{y}"
        else
          @antenna_positions[char] ||= []
          @antenna_positions[char] << [x, y]
        end
      end
    end
    @length = length
    @breadth = breadth
    @antinodes = []
  end

  def solution_1
    @antenna_positions.each do |antenna, positions|
      positions.each_with_index do |position, curr_index|
        positions.each_with_index do |other_position, other_index|
          next if curr_index == other_index
          find_antinode(position, other_position).tap do |antinode|
            if antinode[0] >= 0 && antinode[0] < (@length) && antinode[1] >= 0 && antinode[1] < (@breadth)
              @antinodes << antinode
            end
          end
        end
      end
    end
    print_world
    @antinodes.uniq.length
  end

  def solution_2
  end

  def find_antinode(a, b)
    ax, ay = a
    bx, by = b
    cx = bx + ((bx - ax))
    cy = by + ((by - ay))
    [cx, cy]
  end

  def print_world
    apos = {}
    @antenna_positions.each do |antenna, positions|
      positions.each do |position|
        apos[position] = antenna
      end
    end

    @length.times do |x|
      @breadth.times do |y|
        if @antinodes.include?([x, y])
          print "#"
        elsif apos[[x, y]]
          print apos[[x, y]]
        else
          print "."
        end
      end
      puts
    end
  end
end
