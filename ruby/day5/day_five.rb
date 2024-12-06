ordering_rule_pattern = /\d+\|\d+/
print_updates_pattern = /(\d,)+/

rules = []
print_updates = []

File.readlines("./input.txt").each do |line|
  line.chomp!
  if line.match?(ordering_rule_pattern)
    rules << line.split("|").map(&:to_i)
  elsif line.match?(print_updates_pattern)
    print_updates << line.split(",").map(&:to_i)
  end
end

valid_updates = print_updates.select do |print_seq|
  print_seq.all? do |el|
    rules.all? do |rule|
      if rule.include?(el)
        first_el_index = print_seq.index(rule[0])
        second_el_index = print_seq.index(rule[1])
        unless first_el_index && second_el_index
          true
        else
          first_el_index < second_el_index
        end
      else
        true
      end
    end
  end
end

puts valid_updates.inspect
puts valid_updates.length
answer = valid_updates.sum do |print_seq|
  print_seq[print_seq.length / 2].to_i
end

puts answer
