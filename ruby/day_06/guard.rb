class Guard
  attr_reader :row, :column, :direction

  def initialize(row:, column:, direction:)
    @row = row
    @column = column
    @direction = direction
  end

  def next
    case direction
    when "U"
      @row -= 1
    when "D"
      @row += 1
    when "L"
      @column -= 1
    when "R"
      @column += 1
    end
    self
  end

  def prev
    case direction
    when "U"
      @row += 1
    when "D"
      @row -= 1
    when "L"
      @column += 1
    when "R"
      @column -= 1
    end
    self
  end

  def turn_right
    new_direction = case direction
      when "U" then "R"
      when "D" then "L"
      when "L" then "U"
      when "R" then "D"
      end
    @direction = new_direction
    self
  end
end
