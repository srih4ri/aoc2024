require "set"
require_relative "guard"
require_relative "world"

class Solution
  EMPTY = "."
  OBSTACLE = "#"
  GUARD = "^"

  def initialize(input_file)
    @input_file = input_file
  end

  def solution_1
    c = Set.new
    find_distinct_patrolled_positions.each { |x, y, d| c << [x, y] }
    c.count
  end

  def solution_2
    find_mutations_with_loops
  end

  def find_distinct_patrolled_positions
    obstacles, guard, length, breadth = parse_input_file

    world = World.new(length: length, breadth: breadth, obstacles: obstacles, guard: guard, patrolled_positions: Set.new)
    patrolled_positions = Set.new
    until world.guard_will_exit?
      #puts "\e[H\e[2J"
      # print_world(world)
      patrolled_positions = world.patrolled_positions
      world = world.next
    end
    patrolled_positions
  end

  def find_mutations_with_loops
    obstacles, guard, length, breadth = parse_input_file

    c = Set.new
    find_distinct_patrolled_positions.each { |x, y, d| c << [x, y] }
    puts "Evaluating #{c.count} distinct patrolled positions"
    i = 0
    iteration_threads = c.map do |x, y|
      #puts "#{i}/#{c}: Checking world with obstacle at #{x}, #{y}"
      if obstacles.include?([x, y])
        next
      else
        #Thread.new do
        puts i += 1
        loops = []
        obs = obstacles.dup.push([x, y])

        world = World.new(length: length, breadth: breadth, obstacles: obs, guard: guard, patrolled_positions: Set.new)

        iterations_without_move = 0
        prev_positions = 0

        until world.guard_will_exit?
          if iterations_without_move > 1
            loops << [x, y]
            # puts "\t\tStuck in same place for more than one loops: #{iterations_without_move}"
            break
          end
          world = world.next
          # puts "\t\tWorld: #{world.patrolled_positions.count}"
          if world.patrolled_positions.count == prev_positions
            # puts "\t\tSame position : #{iterations_without_move}"
            iterations_without_move += 1
          else
          end

          prev_positions = world.patrolled_positions.count
        end

        loops.count
        #end
      end
    end

    iteration_threads.compact!
    #a = iteration_threads.map(&:join).map(&:value)
    a = iteration_threads
    puts a.inspect
    a.sum
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
    print "World\n#{world.patrolled_positions}\n"
    (0..world.length - 1).each do |row|
      (0..world.breadth - 1).each do |column|
        print "\t"
        if world.patrolled_positions.include?([row, column])
          print "X"
          next
        end
        if world.guard.row == row && world.guard.column == column
          print_guard(world.guard.direction)
        elsif world.obstacle_map.include?([row, column])
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
