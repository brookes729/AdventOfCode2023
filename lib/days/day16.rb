def build_and_track_light(x, y, x_diff, y_diff, input)
    output = Array.new(input.length) {Array.new(input[0].length) {0}}
    track_light(x, y, x_diff, y_diff, input, output)
    
    return output.map { |line| line.select { |val| val > 0 }.count } .sum
end

def track_light(x, y, x_diff, y_diff, input, output)
    until x < 0 || y < 0 || x >= input.length || y >= input[x].length do
        if output[x][y] > 8
            break
        end
        output[x][y] += 1
        case input[x][y] 
        when "|"
            if y_diff != 0 then
                track_light(x, y, -1, 0, input, output)
                x_diff = 1
                y_diff = 0
            end
        when "-"
            if x_diff != 0 then
                track_light(x, y, 0, -1, input, output)
                x_diff = 0
                y_diff = 1
            end
        when "/"
            if x_diff != 0 then
                y_diff = -1 * x_diff
                x_diff = 0
            else 
                x_diff = -1 * y_diff
                y_diff = 0
            end
        when "\\"
            if x_diff != 0 then
                y_diff = 1 * x_diff
                x_diff = 0
            else 
                x_diff = 1 * y_diff
                y_diff = 0
            end
        end

        x += x_diff
        y += y_diff
    end
end

input = File.readlines("../inputs/day16.txt")
            .map(&:chomp)
            .map {|line| line.split(//)}

puts build_and_track_light(0, 0, 0, 1, input)

part_2_total = 0
input.each_with_index do |line, row_index|        
    light = build_and_track_light(row_index, 0, 0, 1, input)
    if light > part_2_total then
        part_2_total = light
    end
    light = build_and_track_light(row_index, line.length - 1, 0, -1, input)
    if light > part_2_total then
        part_2_total = light
    end
    if row_index == 0 || row_index == input.length - 1 then
        line.each_with_index do |val, col_index|
            row_diff = row_index == 0 ? 1 : -1
            light = build_and_track_light(row_index, col_index, row_diff, 0, input)
            if light > part_2_total then
                part_2_total = light
            end
        end
    end
end
puts part_2_total