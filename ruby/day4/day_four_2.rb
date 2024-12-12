matrix = File.readlines("input.txt").map { |line| line.chomp.split("") }

star_arm = "MAS"
star_center = "A"

count = 0

def check_star_at(matrix, row, col, star_arm)
  star_found = false
  arm_1 = matrix[row - 1][col - 1] + matrix[row][col] + matrix[row + 1][col + 1]
  arm_2 = matrix[row - 1][col + 1] + matrix[row][col] + matrix[row + 1][col - 1]
  return (arm_1 == star_arm || arm_1 == star_arm.reverse) && (arm_2 == star_arm || arm_2 == star_arm.reverse)
end

(1..(matrix.length - 2)).each do |row_index|
  (1..(matrix.length - 2)).each do |col_index|
    el = matrix[row_index][col_index]
    print "\t#{matrix[row_index][col_index]}"
    if el == star_center
      print "["
      star_found = check_star_at(matrix, row_index, col_index, star_arm)
      print star_found ? "*" : "-"
      if star_found
        count += 1
      end
      print "]"
    else
    end
  end
  puts ""
end

print count
