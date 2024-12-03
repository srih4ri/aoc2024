SMALLEST_SAFE_STEP = 1
LARGEST_SAFE_STEP = 3
paths = File.readlines("input.txt").map(&:chomp).map{|line| line.split.map(&:to_i)}

def is_safe?(path)
  direction = path[0] < path[1] ? :up : :down
  path.each_with_index do |level,index|
    if(index >= path.length - 1)
      # Iterated to end without tripping, we safe
      return true
    end
    if direction == :up
      # Mark unsafe if current step is higher than next step
      return false if level > path[index+1]
    else 
      # Mark unsafe if current step is lower than next step
      return false if level < path[index+1]
    end
    step_size = (level - path[index+1]).abs
    if step_size < SMALLEST_SAFE_STEP or step_size > LARGEST_SAFE_STEP
      # Step size too small/large, path unsafe
      return false
    end
  end
end

safe_paths = paths.select do |path|
  is_safe?(path)
end

puts safe_paths.inspect
puts safe_paths.length