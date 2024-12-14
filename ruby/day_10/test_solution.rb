# frozen_string_literal: true

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
test_result(sample_result, 36)

puts "Sample, Solution 2"
sample_result = Solution.new("input_sample.txt").solution_2
test_result(sample_result, 2858)

puts "Actual, Solution 1"
result = Solution.new("input.txt").solution_1
test_result(result, 6_288_599_492_129)

puts "Actual, Solution 2"
result = Solution.new("input.txt").solution_2
test_result(result, 6321896265143)
