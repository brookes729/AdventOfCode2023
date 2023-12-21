def get_size(input, step_goal, start, step_cache)
    old_positions = []
    next_positions = start
    step_count = 0
    
    goal = step_goal
    # puts "Steps to run for answer #{goal}, starting at #{start}"
    if goal.odd? then
        # take a single step to start, because we're taking two at a time after this
        
        new_positions = []
        next_positions.each do |current_pos|
            [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |direction|
                if input[(current_pos[0] + direction[0]) % input.length][(current_pos[1] + direction[1]) % input[current_pos[0] + direction[0]].length] == "." then
                    new_positions.push([current_pos[0] + direction[0], current_pos[1] + direction[1]])
                end
            end
        end
        next_positions = new_positions
        old_positions = []
        step_count = 1
    end
    while step_count < goal
        step_cache[step_count] = (old_positions + next_positions).length
        
        #take two steps, ignore anything we've visted before
        if step_count % 10 == 1 && goal.odd? || step_count % 10 == 0 && goal.even?  then
            positions = old_positions + next_positions
            # puts "\e[H\e[2J"
            # for grid_x in -1..1
            #     input.each_with_index do |line, x|
            #         for grid_y in -1..1
            #             print line.each_with_index.map { |val, y| positions.include?([(input.length * grid_x) + x, (input[0].length * grid_y) + y]) ? "O" : val }.join 
            #         end
            #         puts
            #     end
            # end
            # input.each_with_index { |line, x| puts line.each_with_index.map { |val, y| positions.include?([x,y]) ? "O" : val }.join }
            # puts "#{step_count} steps, #{positions.length} potentials, #{next_positions.length} checks"
            # sleep 0.5
        end
        
        temp_positions = []
        new_positions = []
        next_positions.each do |current_pos|
            [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |direction|
                if current_pos[0] + direction[0] >= 0 && 
                    current_pos[0] + direction[0] < input.length &&
                    current_pos[1] + direction[1] >= 0 && 
                    current_pos[1] + direction[1] < input[0].length &&
                    input[(current_pos[0] + direction[0]) % input.length][(current_pos[1] + direction[1]) % input[0].length] == "." &&
                    !temp_positions.include?([current_pos[0] + direction[0], current_pos[1] + direction[1]])then
                    temp_positions.push([current_pos[0] + direction[0], current_pos[1] + direction[1]])
                end
            end
        end
        temp_positions.each do |current_pos|
            [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |direction|
                if current_pos[0] + direction[0] >= 0 && 
                    current_pos[0] + direction[0] < input.length &&
                    current_pos[1] + direction[1] >= 0 && 
                    current_pos[1] + direction[1] < input[0].length &&
                    input[(current_pos[0] + direction[0]) % input.length][(current_pos[1] + direction[1]) % input[0].length] == "." &&
                    !old_positions.include?([current_pos[0] + direction[0], current_pos[1] + direction[1]]) &&
                    !next_positions.include?([current_pos[0] + direction[0], current_pos[1] + direction[1]]) &&
                    !new_positions.include?([current_pos[0] + direction[0], current_pos[1] + direction[1]]) then
                    new_positions.push([current_pos[0] + direction[0], current_pos[1] + direction[1]])
                end
            end
        end
        old_positions = old_positions + next_positions
        next_positions = new_positions
        step_count += 2
    end
    positions = old_positions + next_positions
    # input.each_with_index { |line, x| puts line.each_with_index.map { |val, y| positions.include?([x,y]) ? "O" : val }.join }
    step_cache[step_count] = positions.length
end

part_1_total = 0
part_2_total = 0


start = [0,0]
input = File.readlines("../inputs/day21.txt").each_with_index.map do |arr, index|
    arr = arr.chomp.split(//)
    if arr.find_index("S") != nil then
        start = [index, arr.find_index("S")]
        arr[arr.find_index("S")] = "."
    end
    arr
end
step_cache_odd = {}
step_cache_even = {}
get_size(input, (input.length).to_i, [start], step_cache_odd)
get_size(input, (input.length).to_i - 1, [start], step_cache_even)
part_1_total = step_cache_odd[(input.length * 0.5).to_i]
puts part_1_total # Part 1 is half the width, 64, luckily also what we need later

even_centre = step_cache_even[(input.length * 0.5).to_i - 1]
# puts even_centre
even_full = step_cache_even[(input.length).to_i - 1]
# puts even_full
odd_full = step_cache_odd[(input.length).to_i]
# puts odd_full


# puts "Part 2"
target = 202300 
# puts "Target = #{target}th grid size"
interior = (target**2 * even_full) + ((target + 1)**2 * odd_full) + (target * (even_full - even_centre)) - ((target + 1) * (odd_full - part_1_total))
puts interior
