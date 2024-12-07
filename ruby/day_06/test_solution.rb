require_relative "solution"

def test_result(x, y)
  if x == y
    puts "Test passed"
  else
    puts "Test failed, expected #{y} but got #{x}"
  end
end

sample_result = Solution.new("input_sample.txt").find_distinct_patrolled_positions
test_result(sample_result, 41)

sample_result = Solution.new("input_sample.txt").find_mutations_with_loops
test_result(sample_result, 6)

result = Solution.new("input.txt").find_mutations_with_loops
puts result