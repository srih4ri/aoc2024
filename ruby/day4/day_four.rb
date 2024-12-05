matrix = File.readlines("input.txt").map { |line| line.chomp.split("") }

search_term = "XMAS"
count = 0


matrix.each_with_index do |row, row_index|
    row.each_with_index do |col, col_index|
        print "\t#{matrix[row_index][col_index]}\t"
    end
    puts 
end
matrix.each_with_index do |row, row_index|
  row.each_with_index do |col, col_index|
    print "\t(#{row_index},#{col_index}):#{matrix[row_index][col_index]}\t"
    hay_lr = matrix[row_index][col_index..col_index + search_term.length - 1].join("")
    if hay_lr == search_term
      count += 1
      print "LR"
    end

    if (col_index + 1 - search_term.length) >= 0
        hay_rl = matrix[row_index][(col_index + 1 - search_term.length)..col_index].join("")
        if hay_rl == search_term.reverse            
            count += 1
            print "RL"   
        end
    end

    if col_index + (search_term.length - 1) < row.length && row_index + (search_term.length - 1) < matrix.length
        hay_d = (0..search_term.length - 1).map { |i| matrix[row_index + i][col_index + i] }.join("")
        if hay_d == search_term
            count += 1
            print "D"
        end
    end

    if row_index - (search_term.length - 1) >= 0 && col_index - (search_term.length - 1) >= 0
        hay_ad = (0..search_term.length - 1).map { |i| matrix[row_index - i][col_index - i] }.join("")
        if hay_ad == search_term
            count += 1
            print "AD"
        end
    end

    if row_index - (search_term.length - 1) >= 0 && col_index + (search_term.length - 1) < row.length
        hay_da = (0..search_term.length - 1).map { |i| matrix[row_index - i][col_index + i] }.join("")
        if hay_da == search_term
            count += 1
            print "DA"
        end
    end

    if row_index + (search_term.length - 1) < matrix.length && col_index - (search_term.length - 1) >= 0
        hay_au = (0..search_term.length - 1).map { |i| matrix[row_index + i][col_index - i] }.join("")
        if hay_au == search_term
            count += 1
            print "AU"
        end
    end

    
    if row_index - (search_term.length - 1) >= 0
        hay_u = (0..search_term.length - 1).map { |i| matrix[row_index - i][col_index] }.join("")
        if hay_u == search_term
            count += 1
            print "U"
        end
    end

    if row_index + (search_term.length - 1) < matrix.length
        hay_d = (0..search_term.length - 1).map { |i| matrix[row_index + i][col_index] }.join("")
        if hay_d == search_term 
            count += 1
            print "D"
        end
    end

  end
  puts ""
end

puts count
