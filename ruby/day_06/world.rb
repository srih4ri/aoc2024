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

  def next
    new_guard = guard.next
    if obstacle_map[new_guard.row] && obstacle_map[new_guard.row][new_guard.column]
      guard.prev
      new_guard = guard.turn_right
    end
    new_patrolled_positions = patrolled_positions.dup.add([new_guard.row, new_guard.column, new_guard.direction])
    @guard = new_guard
    @patrolled_positions = new_patrolled_positions
    self
  end

  def guard_will_exit?
    guard.row < 0 || guard.row >= length || guard.column < 0 || guard.column >= breadth
  end

  private

  def build_obstacle_map(obstacles)
    obstacle_map = {}
    obstacles.each do |x, y|
      obstacle_map[x] ||= {}
      obstacle_map[x][y] = true
    end
    obstacle_map
  end
end
