part_1_total = 0
part_2_total = 0

input = File.readlines("../inputs/day11.txt").map(&:chomp).map {|line| line.split(//)}

empty_rows = *(0..input.length)
empty_columns = *(0..input[0].length)
galaxies = []
input.each_with_index do |line, row|
    empty_line = true
    line.each_with_index do |point, col|
        if point == "#" then
            empty_line = false
            empty_columns.delete(col)
            galaxies.push([row,col])
        end
    end
    if !empty_line then
        empty_rows.delete(row)
    end
end

visited_galaxies = []
galaxies.each do |galaxy|
    visited_galaxies.each do |visited|
        expanded_rows = *([galaxy[0],visited[0]].min..[galaxy[0],visited[0]].max)
        expanded_rows &= empty_rows
        expanded_cols = *([galaxy[1],visited[1]].min..[galaxy[1],visited[1]].max)
        expanded_cols &= empty_columns
        distance = (galaxy[0]-visited[0]).abs + (galaxy[1]-visited[1]).abs + expanded_rows.count + expanded_cols.count
        part_1_total += distance
        distance = (galaxy[0]-visited[0]).abs + (galaxy[1]-visited[1]).abs + (expanded_rows.count * 999999) + (expanded_cols.count * 999999) # Already counted once
        part_2_total += distance
    end
    visited_galaxies.push(galaxy)
end

puts part_1_total
puts part_2_total