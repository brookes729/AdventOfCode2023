def spin_cycle(input, repeats)
    cache = {}
    cache_sum = {}
    loop_starts = 0
    repeats.times do |count|
        cache_key = input.map { |line| line.join }.join
        # if count % 1000 == 0 then
        #     puts count
        # end
        if cache.key? cache_key then
            # puts "#{count} == #{cache[cache_key]} - #{cache_key}"
            if loop_starts == 0 then
                loop_starts = cache[cache_key]
                break
            end
        end
        cache[input.map { |line| line.join }.join] = count
        roll(input, -1, 0)
        roll(input, 0, -1)
        roll(input, 1, 0)
        roll(input, 0, 1)
        cache_sum[count] = input.each_with_index.map { |line, row_index| line.count("O") * (input.length - row_index) }.sum
    end
    # cache.each { |val| puts val.to_s }
    # puts "debug"
    # puts repeats
    # puts loop_starts
    loop_length = cache.length - loop_starts
    # puts loop_length
    loop_repeated_length = loop_length * ((repeats - loop_starts) / loop_length)
    # puts loop_repeated_length
    remaining = repeats - loop_repeated_length
    # puts remaining
    puts cache_sum[remaining - 1]
end

def find_rocks(input, x_diff, y_diff) 
    round_rocks = []
    if x_diff == -1 then 
        input.each_with_index do |row, row_index|
            row.each_with_index do |val, col_index|
                if val == "O" then
                    round_rocks.push([row_index, col_index])
                end
            end
        end
    elsif x_diff == 1 then 
        input.each_with_index do |row, row_index|
            row.each_with_index do |val, col_index|
                if val == "O" then
                    round_rocks.unshift([row_index, col_index])
                end
            end
        end
    elsif y_diff == -1 then 
        input[0].length.times do |col_index|
            input.map { |row| row[col_index]}.each_with_index do |val, row_index|
                if val == "O" then
                    round_rocks.push([row_index, col_index])
                end
            end
        end
    elsif y_diff == 1 then 
        input[0].length.times do |col_index|
            input.map { |row| row[col_index]}.each_with_index do |val, row_index|
                if val == "O" then
                    round_rocks.unshift([row_index, col_index])
                end
            end
        end
    end
    return round_rocks
end

def roll(input, x_diff, y_diff)
    round_rocks = find_rocks(input, x_diff, y_diff)
    # puts round_rocks.to_s
    round_rocks.each do |rock|
        new_pos_x = rock[0]
        new_pos_y = rock[1]
        while new_pos_x + x_diff >= 0 && new_pos_x + x_diff < input.length && new_pos_y + y_diff >= 0 && new_pos_y + y_diff < input[0].length do
            # puts "Rock test: #{rock.to_s} => [#{new_pos_x}, #{new_pos_y}]"
            if input[new_pos_x + x_diff][new_pos_y + y_diff] != "." then
                break
            end
            new_pos_x += x_diff
            new_pos_y += y_diff
        end
        input[new_pos_x][new_pos_y] = "O"
        if new_pos_x != rock[0] || new_pos_y != rock[1] then
            input[rock[0]][rock[1]] = "."
        end
        # puts "Rock: #{rock.to_s} => [#{new_pos_x}, #{new_pos_y}]"
    end
end
    
part_1_total = 0
part_2_total = 0

input = File.readlines("../inputs/day14.txt")
            .map(&:chomp)
            .map {|line| line.split(//)}

# input.each { |line| puts line.join }

roll(input, -1, 0)
# input.each { |line| puts line.join }

part_1_total = input.each_with_index.map { |line, row_index| line.count("O") * (input.length - row_index) }.sum

puts part_1_total
spin_cycle(input, 1000000000)

# puts part_2_total