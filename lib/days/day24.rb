part_1_total = 0
part_2_total = 0

snowballs = []
# test_area = [7, 27]
test_area = [200000000000000, 400000000000000]

File.foreach("../inputs/day24.txt") do |line| 
    line_details = line.chomp().split(" @ ")
    position = line_details[0].split(", ").map(&:to_f)
    velocity = line_details[1].split(", ").map(&:to_f)
    
    # y1 = a1x1 + b1
    # a1 = dy1 / dx1
    # b1 = y1 - a1x1
    a1 = velocity[1] / velocity[0]
    b1 = position[1] - (a1 * position[0])
    # puts "#{position[1]} = #{a1} * #{position[0]} + #{b1} = #{a1 * position[0] + b1}"

    snowballs.each do |existing_ball|
        a2 = existing_ball[2][0]
        b2 = existing_ball[2][1]
        # for colision
        # y = a1x + b1
        # y = a2x + b2
        # puts "#{existing_ball[0][1]} = #{a2} * #{existing_ball[0][0]} + #{b2} = #{a2 * existing_ball[0][0] + b2}"
        # a1x + b1 = a2x + b2 
        # (a1 - a2)x = b2 - b1
        # (b2 - b1) / (a1 - a2) = x
        x_coll = (b2 - b1) / (a1 - a2)
        y_coll = a1 * x_coll + b1
        # y2 = a2 * x_coll + b2
        t1 = (x_coll - position[0]) / velocity[0]
        t2 = (x_coll - existing_ball[0][0]) / existing_ball[1][0]

        # puts "Test #{existing_ball.to_s} vs #{[position, velocity].to_s} \tx = #{'%.2f' % x_coll} => y #{'%.2f' % y_coll} \t@ #{'%.2f' % t1} or #{'%.2f' % t2} "
        if x_coll.between?(test_area[0], test_area[1]) && 
            y_coll.between?(test_area[0], test_area[1]) && 
            t1 > 0 && t2 > 0 then
            part_1_total += 1
        end
    end
    snowballs.push([position, velocity, [a1, b1]])
end

puts part_1_total

# Part 2
rock_position = [-1, -1, -1]
hits = 0

range = 250

for x in -range..range
    for y in -range..range
        rock_position = [-1, -1, -1]
        hits = 0
        missed = false
        snowballs.take(10).each do |first_ball|
            if missed then
                break
            end
            a1 = (first_ball[1][1] - y) / (first_ball[1][0] - x)
            b1 = first_ball[0][1] - (a1 * first_ball[0][0])
            snowballs.take(10).each do |second_ball|
                if first_ball == second_ball then
                    next
                end
                a2 = (second_ball[1][1] - y) / (second_ball[1][0] - x)
                b2 = second_ball[0][1] - (a2 * second_ball[0][0])
                x_coll = (b2 - b1) / (a1 - a2)
                y_coll = a1 * x_coll + b1
                # y2 = a2 * x_coll + b2
                t1 = (x_coll - first_ball[0][0]) / (first_ball[1][0] - x)
                t2 = (x_coll - second_ball[0][0]) / (second_ball[1][0] - x)

                if !x_coll.nan? && x_coll.round(2) % 1 == 0 && y_coll.round(2) % 1 == 0 && t1.round(2) % 1 == 0 && t2.round(2) % 1 == 0 && t1 > 0 && t2 > 0 then
                    hits += 1 
                    z_coll = -1
                    for z in -range..range
                        z1 = first_ball[0][2] + ((first_ball[1][2] - z) * t1)
                        z2 = second_ball[0][2] + ((second_ball[1][2] - z) * t2)
                        
                        if z1 == z2 then
                            # puts "z_coll = #{z1} @ dz = #{z}"
                            z_coll = z1
                            break
                        end
                    end
                    if z_coll == -1 then 
                        missed = true
                        break
                    end

                    # puts "x = #{'%.2f' % x_coll} \ty = #{'%.2f' % y_coll} \tz =  #{'%.2f' % z_coll} "

                    if rock_position == [-1, -1, -1] then
                        rock_position = [x_coll, y_coll, z_coll]
                    elsif rock_position[0].round(2) != x_coll.round(2) || rock_position[1].round(2) != y_coll.round(2) || rock_position[2].round(2) != z_coll.round(2) then
                        missed = true
                        break
                    end
                end
            end
        end
        if rock_position != [-1, -1, -1] && hits > 5 then
            # puts "break: y = #{y}"
            break
        end
    end
    if rock_position != [-1, -1, -1] && hits > 5 then
        # puts "break: x = #{x}"
        break
    end
end

puts rock_position.to_s


puts rock_position.sum