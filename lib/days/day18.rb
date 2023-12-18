def do_magic(trench_map, range)
    output = 0
    squares = []
    # draw_map(trench_map, range)
    # puts
    
    while trench_map.length > 4
        # puts trench_map.length
        # puts trench_map.to_s
        # puts
        # puts "next round"
        # draw_map(trench_map, range)
        for x in 0..trench_map.length - 3
            if trench_map[x][0] == trench_map[x+1][0] &&
                trench_map[x][1] < trench_map[x+1][1] &&
                trench_map[x+1][0] < trench_map[x+2][0] then
                if trench_map.select { |point| point[0] >= trench_map[x][0] && point[0] <= trench_map[x+2][0] && point[1] >= trench_map[x][1] && point[1] <= trench_map[x+2][1] }.length == 3 then
                    squares.push([trench_map[x][0], trench_map[x+2][0], trench_map[x][1], trench_map[x+2][1]])
                    # puts "#{trench_map[x].to_s} #{trench_map[x+1].to_s} #{trench_map[x+2].to_s}"
                    # puts "Internal R D: height #{trench_map[x][0]} - #{trench_map[x+2][0]} width #{trench_map[x][1]} - #{trench_map[x+2][1]} leave [#{trench_map[x+2][0]}, #{trench_map[x][1]}]"
                    # puts trench_map.to_s
                    trench_map = trench_map[0,x] + [[trench_map[x+2][0], trench_map[x][1]]] + trench_map[x+3..-1]
                    # puts trench_map.to_s
                    break
                end
            elsif trench_map[x][1] == trench_map[x+1][1] &&
                trench_map[x][0] < trench_map[x+1][0] &&
                trench_map[x+1][1] > trench_map[x+2][1] then
                if trench_map.select { |point| point[0] >= trench_map[x][0] && point[0] <= trench_map[x+2][0] && point[1] >= trench_map[x+2][1] && point[1] <= trench_map[x][1] }.length == 3 then
                    squares.push([trench_map[x][0], trench_map[x+2][0], trench_map[x+2][1], trench_map[x][1]])
                    # puts "#{trench_map[x].to_s} #{trench_map[x+1].to_s} #{trench_map[x+2].to_s}"
                    # puts "Internal D L: height #{trench_map[x][0]} - #{trench_map[x+2][0]} width #{trench_map[x+2][1]} - #{trench_map[x][1]} leave [#{trench_map[x][0]}, #{trench_map[x+2][1]}] "
                    # puts trench_map.to_s
                    trench_map = trench_map[0,x] + [[trench_map[x][0], trench_map[x+2][1]]] + trench_map[x+3..-1]
                    # puts trench_map.to_s
                    break
                end
            elsif trench_map[x][0] == trench_map[x+1][0] &&
                trench_map[x][1] > trench_map[x+1][1] &&
                trench_map[x+1][0] > trench_map[x+2][0] then
                if trench_map.select { |point| point[0] >= trench_map[x+2][0] && point[0] <= trench_map[x][0] && point[1] >= trench_map[x+2][1] && point[1] <= trench_map[x][1] }.length == 3 then
                    squares.push([trench_map[x+2][0], trench_map[x][0], trench_map[x+2][1], trench_map[x][1]])
                    # puts "#{trench_map[x].to_s} #{trench_map[x+1].to_s} #{trench_map[x+2].to_s}"
                    # puts "Internal L U: height #{trench_map[x+2][0]} - #{trench_map[x][0]} width #{trench_map[x+2][1]} - #{trench_map[x][1]} leave [#{trench_map[x+2][0]}, #{trench_map[x][1]}] "
                    # puts trench_map.to_s
                    trench_map = trench_map[0,x] + [[trench_map[x+2][0], trench_map[x][1]]] + trench_map[x+3..-1]
                    # puts trench_map.to_s
                    break
                end
            elsif trench_map[x][1] == trench_map[x+1][1] &&
                trench_map[x][0] > trench_map[x+1][0] &&
                trench_map[x+1][1] < trench_map[x+2][1] then
                if trench_map.select { |point| point[0] >= trench_map[x+2][0] && point[0] <= trench_map[x][0] && point[1] >= trench_map[x][1] && point[1] <= trench_map[x+2][1] }.length == 3 then
                    squares.push([trench_map[x+2][0], trench_map[x][0], trench_map[x][1], trench_map[x+2][1]])
                    # puts "#{trench_map[x].to_s} #{trench_map[x+1].to_s} #{trench_map[x+2].to_s}"
                    # puts "Internal U R: height #{trench_map[x+2][0]} - #{trench_map[x][0]} width #{trench_map[x][1]} - #{trench_map[x+2][1]} leave [#{trench_map[x][0]}, #{trench_map[x+2][1]}] "
                    # puts trench_map.to_s
                    trench_map = trench_map[0,x] + [[trench_map[x][0], trench_map[x+2][1]]] + trench_map[x+3..-1]
                    # puts trench_map.to_s
                    break
                end
            end
        end
    end
    # get the last square
    squares.push([trench_map.map { |node| node[0] }.min, trench_map.map { |node| node[0] }.max, trench_map.map { |node| node[1] }.min, trench_map.map { |node| node[1] }.max])
    # puts squares.length
    
    counted_squares = []
    while squares.length > 0
        # puts squares.length
        square = squares.pop()
        output += (square[1] - square[0] + 1) * (square[3] - square[2] + 1)
        clash = []
        counted_squares.each do |counted_square|
            if counted_square[0] == square[1] && ([counted_square[3], square[3]].min -  [counted_square[2], square[2]].max + 1) > 1 then
                y_crash = *(([counted_square[2], square[2]].max)..([counted_square[3], square[3]].min))
                clash += y_crash.map { |y|  [square[1],y]}
                # puts "y1 Crash! #{counted_square.to_s} #{square.to_s} clash = #{clash}"
            end
            if counted_square[1] == square[0] && ([counted_square[3], square[3]].min -  [counted_square[2], square[2]].max + 1) > 1 then
                y_crash = *(([counted_square[2], square[2]].max)..([counted_square[3], square[3]].min))
                clash += y_crash.map { |y|  [square[0],y]}
                # puts "y2 Crash! #{counted_square.to_s} #{square.to_s} clash = #{clash}"
            end
            if counted_square[2] == square[3] && ([counted_square[1], square[1]].min -  [counted_square[0], square[0]].max + 1) > 0 then
                x_crash = *(([counted_square[0], square[0]].max)..([counted_square[1], square[1]].min))
                clash += x_crash.map { |x|  [x, square[3]]}
                # puts "x1 Crash! #{counted_square.to_s} #{square.to_s} clash = #{clash}"
            end
            if counted_square[3] == square[2] && ([counted_square[1], square[1]].min -  [counted_square[0], square[0]].max + 1) > 0 then
                x_crash = *(([counted_square[0], square[0]].max)..([counted_square[1], square[1]].min))
                clash += x_crash.map { |x|  [x, square[2]]}
                # puts "x2 Crash! #{counted_square.to_s} #{square.to_s} clash = #{clash}"
            end
        end
        output -= clash.uniq.length
        counted_squares.push(square)
    end
    return output
end

def draw_map(map, range)
    for x in range[0]..range[1] do
        print "#{x}: "
        for y in range[2]..range[3] do
            if map.include? [x,y] then
                print "#{x},#{y}\t"
            else
                print ".\t"
            end
        end
        puts
    end
end

part_1_total = 0
part_2_total = 0

direction_map = {
    "R" => [0, 1],
    "L" => [0, -1],
    "U" => [-1, 0],
    "D" => [1, 0]
}
direction_map_2 = {
    "0" => [0, 1],
    "1" => [1, 0],
    "2" => [0, -1],
    "3" => [-1, 0]
}


trench_map = []
trench_map_2 = []
current_pos = [0, 0]
current_pos_2 = [0, 0]
range = [0, 0, 0, 0]
# range is used to draw, don't do that for part 2

input = File.readlines("../inputs/day18.txt")
            .map(&:chomp)
            .each do |instruction|
                direction = instruction.split()[0]
                distance = instruction.split()[1].to_i
                current_pos = [current_pos[0] + (direction_map[direction][0] * distance), current_pos[1] + (direction_map[direction][1] * distance)]
                trench_map.push(current_pos)
                range = [
                    [range[0],current_pos[0]].min,
                    [range[1],current_pos[0]].max,
                    [range[2],current_pos[1]].min,
                    [range[3],current_pos[1]].max
                ]
                # Part 2
                direction_2 = instruction.split()[2][-2]
                distance_2 = ('0x' + instruction.split()[2][2..-3]).to_i(16)
                # puts "#{direction_map_2[direction_2].to_s} => #{distance_2}"
                current_pos_2 = [current_pos_2[0] + (direction_map_2[direction_2][0] * distance_2), current_pos_2[1] + (direction_map_2[direction_2][1] * distance_2)]
                trench_map_2.push(current_pos_2)
            end


# t1 = Time.now
puts do_magic(trench_map, range)
# t2 = Time.now
# puts t2- t1
puts do_magic(trench_map_2, range)
# puts Time.now - t2