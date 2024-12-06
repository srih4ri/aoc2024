# Read the file
file_path = './input.txt'
lines = File.readlines(file_path).map(&:chomp)

# Separate rules and lists
rules = []
lists = []
is_rule_section = true

lines.each do |line|
  if line.empty?
    is_rule_section = false
    next
  end

  if is_rule_section
    rules << line.split('|').map(&:to_i)
  else
    lists << line.split(',').map(&:to_i)
  end
end

# Create a hash for rule-based ordering
order_hash = {}
rules.each_with_index do |(first, second), index|
  order_hash[first] ||= {}
  order_hash[first][second] = index
end

def custom_sort(list, order_hash)
  list.sort do |a, b|    
    if order_hash[a] && order_hash[a][b]
      -1
    elsif order_hash[b] && order_hash[b][a]
      1
    else
      0
    end
  end
end

def violates_rules?(list, rules)
  rules.any? do |rule|
    next unless list.include?(rule[0]) && list.include?(rule[1])
    list.index(rule[0]) > list.index(rule[1])
  end
end

wrong_lists = lists.select{ |list|
  violates_rules?(list, rules) 
}


sorted_lists = wrong_lists.map { |list| custom_sort(list, order_hash) }

# Output the sorted lists
mid_point_sum = sorted_lists.sum do |sorted_list|
  mid_index = sorted_list.length / 2
  sorted_list[mid_index]
end

puts mid_point_sum