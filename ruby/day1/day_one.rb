lists = File.readlines("input.txt").map!(&:chomp)

list_1 = []
list_2 = []

lists.each do |list|
  list_1 << list.split(" ")[0]
  list_2 << list.split(" ")[1]
end

list_1.sort!
list_2.sort!

distance = 0

list_1.each_with_index do |item, index|
  distance += (item.to_i - list_2[index].to_i).abs
end

puts distance.inspect
