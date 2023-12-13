def line_difference(line_1, line_2) 
    diff_count = 0
    line_1.each_with_index do |val, index|
        if val != line_2[index] then
            diff_count += 1
        end
    end
    return diff_count
end

part_1_total = 0
part_2_total = 0

map = []
maps = []

File.foreach("../inputs/day13.txt") do |line| 
    line = line.chomp
    if line == "" then
        maps.push(map)
        map = []
        next
    end
    map.push(line.split(//))
end

# last map isn't on a blank line
maps.push(map)

maps.each_with_index do |map, map_index|
    map.each_with_index do |row, row_index|
        #puts "#{row_index} \t#{row.join}"
        if row_index == 0 then
            next
        end

        test_index = 0
        match_found = false
        while row_index + test_index < map.length && row_index - test_index > 0 do
            # puts "#{test_index} \t\t#{map[row_index - test_index - 1].join} == #{map[row_index + test_index].join}"
            if map[row_index - test_index - 1] != map[row_index + test_index] then
                #puts "#{test_index} \t\t#{map[row_index - test_index - 1].join} != #{map[row_index + test_index].join}"
                match_found = false
                break
            end
            test_index += 1
            if row_index + test_index == map.length || row_index - test_index == 0 then
                match_found = true
            end
        end
        if match_found then
            # puts "Match! #{row_index}"
            part_1_total += row_index * 100
        end
    end
    (1..map[0].length).each do |col_index|
        # puts "#{row_index} \t#{map.map { |row| row[col_index]}.join}"
        test_index = 0
        match_found = false
        while col_index + test_index < map[0].length && col_index - test_index > 0 do
            # puts "#{test_index} \t\t#{map.map { |row| row[col_index - test_index - 1]}.join} == #{map.map { |row| row[col_index + test_index]}.join}"
            if map.map { |row| row[col_index - test_index - 1]} != map.map { |row| row[col_index + test_index]} then
                # puts "#{test_index} \t\t#{map.map { |row| row[col_index - test_index - 1]}.join} != #{map.map { |row| row[col_index + test_index]}.join}"
                match_found = false
                break
            end
            test_index += 1
            if col_index + test_index == map[0].length || col_index - test_index == 0 then
                match_found = true
            end
        end
        if match_found then
            # puts "Match! #{col_index}"
            part_1_total += col_index
        end
    end
end
puts 
puts part_1_total
maps.each_with_index do |map, map_index|
    #puts map_index
    mirror_found = false
    map.each_with_index do |row, row_index|
        #puts "#{row_index} \t#{row.join}"
        if row_index == 0 then
            next
        end

        test_index = 0
        match_found = false
        smudge_found = false
        while row_index + test_index < map.length && row_index - test_index > 0 do
            # puts "#{test_index} \t\t#{map[row_index - test_index - 1].join} == #{map[row_index + test_index].join}"
            diff = line_difference(map[row_index - test_index - 1], map[row_index + test_index])
            if !smudge_found && diff == 1 then
                smudge_found = true
                diff = 0
            end
            if diff > 0 then
                #puts "#{test_index} \t\t#{map[row_index - test_index - 1].join} != #{map[row_index + test_index].join}"
                match_found = false
                break
            end
            test_index += 1
            if row_index + test_index == map.length || row_index - test_index == 0 then
                match_found = true
            end
        end
        if match_found && smudge_found then
            # puts "#{map_index} R Match! #{row_index}"
            part_2_total += row_index * 100
            mirror_found = true
            break
        end
    end
    if mirror_found then
        next
    end
    (1..map[0].length).each do |col_index|
        # puts "#{row_index} \t#{map.map { |row| row[col_index]}.join}"
        test_index = 0
        match_found = false
        smudge_found = false
        while col_index + test_index < map[0].length && col_index - test_index > 0 do
            # puts "#{test_index} \t\t#{map.map { |row| row[col_index - test_index - 1]}.join} == #{map.map { |row| row[col_index + test_index]}.join}"
            diff = line_difference(map.map { |row| row[col_index - test_index - 1]}, map.map { |row| row[col_index + test_index]} )
            if !smudge_found && diff == 1 then
                smudge_found = true
                diff = 0
            end
            if diff > 0 then
                # puts "#{test_index} \t\t#{map.map { |row| row[col_index - test_index - 1]}.join} != #{map.map { |row| row[col_index + test_index]}.join}"
                match_found = false
                break
            end
            test_index += 1
            if col_index + test_index == map[0].length || col_index - test_index == 0 then
                match_found = true
            end
        end
        if match_found && smudge_found then
            #puts "#{map_index} C Match! #{col_index}"
            part_2_total += col_index
            mirror_found = true
        end
    end
    if ! mirror_found then
        puts map_index
    end
end
puts 
puts part_2_total