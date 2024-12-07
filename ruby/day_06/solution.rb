class Guard
  attr_reader :row, :column, :direction

  def initialize(row:, column:, direction:)
    @row = row
    @column = column
    @direction = direction
  end

  def next
    case direction
    when "U" then Guard.new(row: row - 1, column: column, direction: direction)
    when "D" then Guard.new(row: row + 1, column: column, direction: direction)
    when "L" then Guard.new(row: row, column: column - 1, direction: direction)
    when "R" then Guard.new(row: row, column: column + 1, direction: direction)
    end
  end

  def turn_right
    new_direction = case direction
      when "U" then "R"
      when "D" then "L"
      when "L" then "U"
      when "R" then "D"
      end
    Guard.new(row: row, column: column, direction: new_direction)
  end
end

class World
  attr_reader :length, :breadth, :obstacles, :guard, :obstacle_map, :patrolled_positions

  def initialize(breadth:, length:, obstacles:, guard:, patrolled_positions:)
    @breadth = breadth
    @length = length
    @obstacles = obstacles
    @guard = guard
    @patrolled_positions = patrolled_positions
    @obstacle_map = build_obstacle_map(obstacles)
  end

  def guard_will_exit?
    case guard.direction
    when "U" then guard.row == 0
    when "D" then guard.row == length
    when "L" then guard.column == 0
    when "R" then guard.column == breadth
    end
  end

  def next
    patrolled_positions << [guard.row, guard.column]
    new_guard = guard.next
    if guard_hits_obstacle?(new_guard)
      new_guard = guard.turn_right
    else
      new_guard = guard.next
    end

    World.new(length: length, breadth: breadth, obstacles: obstacles, guard: new_guard, patrolled_positions: patrolled_positions)
  end

  private

  def build_obstacle_map(obstacles)
    obstacles.each_with_object({}) do |(row, column), map|
      map[row] ||= {}
      map[row][column] = true
    end
  end

  def guard_hits_obstacle?(g)
    obstacle_map.dig(g.row, g.column) || false
  end
end

class Solution
  EMPTY = "."
  OBSTACLE = "#"
  GUARD = "^"

  def initialize(input_file)
    @input_file = input_file
  end

  def call
    find_mutations_with_loops()
  end

  def find_mutations_with_loops
    obstacles, guard, length, breadth = parse_input_file
    loops = []

    (1..(length * breadth)).each do |i|      
      
      x = i % length
      y = i / length
      if obstacles.include?([x, y])
        next
      else
        obstacles << [x, y]
      end

      world_steps_traversed = nil
      world = World.new(length: length, breadth: breadth, obstacles: obstacles, guard: guard, patrolled_positions: Set.new)
      
      no_movement = 0
      until world.guard_will_exit?
        
        world = world.next
        
        if no_movement > world.patrolled_positions.count
          loops << [x, y]
          break
        end

        if world_steps_traversed.nil?
          world_steps_traversed = world.patrolled_positions.count
        elsif world_steps_traversed == world.patrolled_positions.count
          no_movement += 1
        elsif world.patrolled_positions.count > world_steps_traversed
          no_movement = 0
        end
        
        world_steps_traversed = world.patrolled_positions.count
      end
      obstacles.pop
      
    end
    loops.count
  end

  def find_distinct_patrolled_positions
    obstacles, guard, length, breadth = parse_input_file

    world = World.new(length: length, breadth: breadth, obstacles: obstacles, guard: guard, patrolled_positions: Set.new)

    until world.guard_will_exit?
      #puts "\e[H\e[2J"
      #print_world(world)
      world = world.next
    end
    world.patrolled_positions.count
  end

  private

  def parse_input_file
    obstacles = []
    guard = nil
    length = 0
    breadth = 0

    File.open(@input_file, "r") do |file|
      file.each_with_index do |line, row|
        length += 1
        breadth = line.chomp.length
        line.chomp.chars.each_with_index do |char, column|
          case char
          when OBSTACLE
            obstacles << [row, column]
          when GUARD
            guard = Guard.new(row: row, column: column, direction: "U")
          end
        end
      end
    end

    [obstacles, guard, length, breadth]
  end

  def print_world(world)
    puts "\e[H\e[2J"
    (0..world.length - 1).each do |row|
      (0..world.breadth - 1).each do |column|
        print "\t"
        if world.patrolled_positions.include?([row, column])
          print "X"
          next
        end
        if world.guard.row == row && world.guard.column == column
          print_guard(world.guard.direction)
        elsif world.obstacle_map[row] && world.obstacle_map[row][column]
          print "#"
        else
          print "."
        end
      end
      puts "\t"
    end
  end

  def print_guard(direction)
    case direction
    when "U" then print "^"
    when "D" then print "v"
    when "L" then print "<"
    when "R" then print ">"
    end
  end
end
