lists = File.readlines("input.txt").map!(&:chomp)

list_1 = []
list_2 = []

lists.each do |list|
  list_1 << list.split(" ")[0].to_i
  list_2 << list.split(" ")[1].to_i
end

occurrences = {}
list_2.each do |item|
  if occurrences[item].nil?
    occurrences[item] = 1
  else
    occurrences[item] += 1
  end
end

similarity = 0
list_1.each do |item|
  similarity += item * (occurrences[item] || 0)
end

puts similarity.inspect
