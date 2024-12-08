class Solution
  attr_reader :input_file_name

  def initialize(input_file_name)
    @input_file_name = input_file_name
  end

  def solution_1(operators = ["+", "*"])
    File.readlines(input_file_name).sum do |line|
      answer, numbers = parse_line(line)
      terms_can_be_combined(answer, numbers, operators) ? answer : 0
    end
  end

  def solution_2
    solution_1(["+", "*", "||"])
  end

  private

  def parse_line(line)
    answer_str, numbers_str = line.chomp.split(":")
    [answer_str.to_i, numbers_str.split.map(&:to_i)]
  end

  def terms_can_be_combined(answer, terms, operators)
    return false if terms.any? { |term| term > answer }

    operators.repeated_permutation(terms.length - 1).any? do |ops|
      calculate_result(terms, ops, answer) == answer
    end
  end

  def calculate_result(terms, ops, answer)
    result = terms[0]
    terms[1..-1].each_with_index do |term, i|
      result = apply_operator(result, term, ops[i])
      break if result > answer
    end
    result
  end

  def apply_operator(left, right, operator)
    case operator
    when "+" then left + right
    when "*" then left * right
    when "||" then "#{left}#{right}".to_i
    end
  end
end
