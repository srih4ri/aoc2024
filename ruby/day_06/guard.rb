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
