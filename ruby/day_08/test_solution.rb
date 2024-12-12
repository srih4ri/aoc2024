require_relative "solution"

def test_result(x, y)
  if x == y
    puts "Test passed"
  else
    puts "Test failed, expected #{y} but got #{x}"
    exit
  end
end

puts "Sample, Solution 1"
sample_result = Solution.new("input_sample.txt").solution_1
test_result(sample_result, 14)

puts "Actual, Solution 1"
result = Solution.new("input.txt").solution_1
test_result(result, 354)

puts "Sample, Solution 2"
sample_result = Solution.new("input_sample.txt").solution_2
test_result(sample_result, 34)

puts "Actual, Solution 2"
result = Solution.new("input.txt").solution_2
puts result
