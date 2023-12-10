def update_output(x, y, output, move_count)
    if output[x][y] == -1 || output[x-1][y] > move_count then
        output[x][y] = move_count
        return true
    end
    return false
end

def move_north(x, y, input_map, output, move_count) # x-1
    next_option = []
    if x == 0 then
        return next_option
    end
    # puts "Move North from #{x},#{y} onto #{input_map[x-1][y]}"
    if input_map[x-1][y] == "|" then
        if update_output(x-1, y, output, move_count) then
            next_option.push(["N", x-1, y, move_count + 1])
        end
    elsif input_map[x-1][y] == "F" then
        if update_output(x-1, y, output, move_count) then
            next_option.push(["E", x-1, y, move_count + 1])
        end
    elsif input_map[x-1][y] == "7" then
        if update_output(x-1, y, output, move_count) then
            next_option.push(["W", x-1, y, move_count + 1])
        end
    end
    # puts "Next: #{next_option}"
    return next_option
end
def move_west(x, y, input_map, output, move_count) # y-1
    next_option = []
    if y == 0 then
        return next_option
    end
    # puts "Move West from #{x},#{y} onto #{input_map[x][y-1]}"
    if input_map[x][y-1] == "-" then
        if update_output(x, y-1, output, move_count) then
            next_option.push(["W", x, y-1, move_count + 1])
        end
    elsif input_map[x][y-1] == "F" then
        if update_output(x, y-1, output, move_count) then
            next_option.push(["S", x, y-1, move_count + 1])
        end
    elsif input_map[x][y-1] == "L" then
        if update_output(x, y-1, output, move_count) then
            next_option.push(["N", x, y-1, move_count + 1])
        end
    end
    # puts "Next: #{next_option}"
    return next_option
end
def move_south(x, y, input_map, output, move_count) # x+1
    next_option = []
    if x == input_map.length - 1 then
        return next_option
    end
    # puts "Move South from #{x},#{y} onto #{input_map[x+1][y]}"
    if input_map[x+1][y] == "|" then
        if update_output(x+1, y, output, move_count) then
            next_option.push(["S", x+1, y, move_count + 1])
        end
    elsif input_map[x+1][y] == "J" then
        if update_output(x+1, y, output, move_count) then
            next_option.push(["W", x+1, y, move_count + 1])
        end
    elsif input_map[x+1][y] == "L" then
        if update_output(x+1, y, output, move_count) then
            next_option.push(["E", x+1, y, move_count + 1])
        end
    end
    # puts "Next: #{next_option}"
    return next_option
end
def move_east(x, y, input_map, output, move_count) # y+1
    next_option = []
    if y == input_map[x].length - 1 then
        return next_option
    end
    # puts "Move East from #{x},#{y} onto #{input_map[x][y+1]}"
    if input_map[x][y+1] == "-" then
        if update_output(x, y+1, output, move_count) then
            next_option.push(["E", x, y+1, move_count + 1])
        end
    elsif input_map[x][y+1] == "J" then
        if update_output(x, y+1, output, move_count) then
            next_option.push(["N", x, y+1, move_count + 1])
        end
    elsif input_map[x][y+1] == "7" then
        if update_output(x, y+1, output, move_count) then
            next_option.push(["S", x, y+1, move_count + 1])
        end
    end
    # puts "Next: #{next_option}"
    return next_option
end

def inner_count(output, input_map)
    count = 0
    output.each_with_index do |arr, x|
        open_pipes = 0
        arr.each_with_index do |val, y| 
            #puts "#{x} #{y} => #{val} => #{input_map[x][y]} Open = #{open_pipes}"
            if val == -1 && open_pipes.odd? then
                count += 1
            elsif val == -1 
                output[x][y] = 0
            else
                case input_map[x][y]
                when "|"
                    open_pipes += 1
                when "F"
                    open_pipes += 1
                when "7"
                    open_pipes += 1
                when "S" 
                    if output[x+1][y] == 1 then 
                        open_pipes += 1
                    end
                end
            end
        end
    end
    return count
end

part_1_total = 0
part_2_total = 0

start = [0,0]
input = File.readlines("../inputs/day10.txt").each_with_index.map do |arr, index|
    arr = arr.chomp.split(//)
    if arr.find_index("S") != nil then
        start = [index, arr.find_index("S")]
    end
    arr
end

#input.each { |line| puts line.join  }
output = Array.new(input.length) {Array.new(input[0].length) {-1}}
# puts 
output[start[0]][start[1]] = 0
next_option = [["N", start[0], start[1], 1],
               ["E", start[0], start[1], 1],
               ["S", start[0], start[1], 1],
               ["W", start[0], start[1], 1]]
while next_option.length > 0
    # puts next_option.to_s
    # puts "\e[H\e[2J"
    # output.each { |line| puts line.join("\t")  }
    # sleep 1
    new_options = []
    next_option.each do |option|
        case option[0]
        when "N"
            new_options = new_options + move_north(option[1], option[2], input, output, option[3])
        when "E"
            new_options = new_options + move_east(option[1], option[2], input, output, option[3])
        when "S"
            new_options = new_options + move_south(option[1], option[2], input, output, option[3])
        when "W"
            new_options = new_options + move_west(option[1], option[2], input, output, option[3])
        end
    end
    next_option = new_options
end

# output.each_with_index { |line, x| puts line.each_with_index.map { |val, y| val == -1 ? "." : input[x][y] }.join("")  }

puts output.map { |arr| arr.max }.max

puts inner_count(output, input)
# output.each_with_index { |line, x| puts line.each_with_index.map { |val, y| val == -1 ? "X" : "." }.join("")  }
