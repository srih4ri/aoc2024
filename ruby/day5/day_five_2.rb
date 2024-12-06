ordering_rule_pattern = /\d+\|\d+/
print_updates_pattern = /(\d,)+/

def rule_satisfied?(sequence, rule)
first_el_index = sequence.index(rule[0])
second_el_index = sequence.index(rule[1])
print "#{rule[0]}: #{first_el_index}; #{rule[1]}: #{second_el_index} \t"

  val = if first_el_index && second_el_index
    first_el_index < second_el_index
  else
    true
  end
  puts val.inspect
  val 
end

def first_violating_rule(sequence, rules)
  rules.detect do |rule|
    puts "Checking rule: #{rule.inspect}"
    !rule_satisfied?(sequence, rule)
  end
end

def correct_sequence(sequence, fvr)
  sequence_copy = sequence.dup
    first_el_index = sequence_copy.index(fvr[0])
    second_el_index = sequence_copy.index(fvr[1])
    if first_el_index && second_el_index
        sequence_copy[first_el_index], sequence_copy[second_el_index] = sequence_copy[second_el_index], sequence_copy[first_el_index]
    end
    sequence_copy
end

def mid_value(sequence)
    return nil if sequence.length.even?
    sequence[sequence.length / 2].to_i
end

ordering_rules = []
print_sequences = []

File.readlines("./input_sample.txt").each do |line|
  line.chomp!
  if line.match?(ordering_rule_pattern)
    ordering_rules << line.split("|").map(&:to_i)
  elsif line.match?(print_updates_pattern)
    print_sequences << line.split(",").map(&:to_i)
  end
end

sum = 0
print_sequences.each do |print_sequence|
    puts "Checking sequence: #{print_sequence.inspect}"
  fvr = first_violating_rule(print_sequence, ordering_rules)
  if fvr.nil?
    puts "Sequence is valid: next"
    next
  else
    puts "Correcting for rule #{fvr}: #{print_sequence.inspect}"
    corrected_sequence = correct_sequence(print_sequence, fvr)
    puts "Corrected sequence: #{corrected_sequence.inspect}"
    sum += mid_value(correct
  end
end

puts sum
