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
    if obstacle_map.include?([new_guard.row, new_guard.column])
      new_guard = guard.turn_right
    end
    new_patrolled_positions = patrolled_positions.dup.add([new_guard.row, new_guard.column, new_guard.direction])
    World.new(breadth: breadth, length: length, obstacles: obstacles, guard: new_guard, patrolled_positions: new_patrolled_positions)
  end

  def guard_will_exit?
    guard.row < 0 || guard.row >= length || guard.column < 0 || guard.column >= breadth
  end

  private

  def build_obstacle_map(obstacles)
    obstacles.to_set
  end
end
