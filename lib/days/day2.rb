














part_1_max = { "red" => 12, "green" => 13, "blue" => 14}


part_1_total = 0
part_2_total = 0
File.foreach("../inputs/day2.txt") do |line| 
    line_details = line.split(/: /)
    game_id = line_details[0].split[1].to_i

    possible = true
    part_2_potential = { "red" => 0, "green" => 0, "blue" => 0}

    line_details[1].split(/; /) do |attempt| 
        attempt.split(/, /) do |ball| 
            if part_1_max[ball.split[1]] < ball.split[0].to_i 
                possible = false
            end
            if part_2_potential[ball.split[1]] < ball.split[0].to_i 
                part_2_potential[ball.split[1]] = ball.split[0].to_i 
            end
        end
    end

    if possible
        part_1_total += game_id
    end

    part_2_total += part_2_potential["red"]* part_2_potential["green"]* part_2_potential["blue"]

end

puts part_1_total
puts part_2_total