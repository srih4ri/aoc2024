ta = Array.new(6){rand}.map{Array.new(6){rand}}
puts ta.flatten.sum
puts ta.inspect

row_sum_threads = ta.length.times.map do |i|
  Thread.new do
    ta[i].sum
  end
end

row_sum_threads.join

puts row_sum_threads.map(&:value).sum