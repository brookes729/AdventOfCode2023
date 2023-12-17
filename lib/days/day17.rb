part_1_total = 0
part_2_total = 0

input = File.readlines("../inputs/day17.txt")
            .map(&:chomp)
            .map {|line| line.split(//).map(&:to_i)}

# input.each { |line| puts line.join }

visited_nodes = {}
# { heat_loss : [x, y, x_diff, y_diff, remaining_straight_line, heat_lost] }
next_nodes = { 0 => [[0, 0, 0, 1, 3, 0]] }

distance_counter = 0
while next_nodes.length > 0
    if next_nodes.key? distance_counter then
        while next_nodes[distance_counter].length > 0
            node = next_nodes[distance_counter].pop()
            new_distance = node[5] + input[node[0]][node[1]]
            visitied_node_key = [node[0], node[1], node[2], node[3], node[4]]
            if visited_nodes.key?(visitied_node_key) &&
                visited_nodes[visitied_node_key][0] < new_distance then
                # puts "Skip: #{visitied_node_key} => #{visited_nodes[visitied_node_key]} < #{new_distance}"
                next
            end
            visited_nodes[visitied_node_key] = node[5]
            [[0, 1],[0, -1],[1, 0],[-1, 0]].each do |direction|
                if direction[0] == -1 * node[2] && direction[1] == -1 * node[3] then
                    next # no turning around
                end
                if node[0] + direction [0] < 0 || 
                    node[0] + direction [0] >= input.length || 
                    node[1] + direction [1] < 0 || 
                    node[1] + direction [1] >= input[node[0]].length then
                    # puts "Skip: #{direction.to_s} => #{node.to_s}"
                    next # Off the map
                end
                next_nodes[new_distance] ||= []
                if direction[0] == node[2] && direction[1] == node[3] then
                    if node[4] > 1 then
                        next_nodes[new_distance].push([node[0] + direction[0], 
                                                        node[1] + direction[1], 
                                                        direction[0], 
                                                        direction[1], 
                                                        node[4] - 1, 
                                                        new_distance])
                    end
                else
                    next_nodes[new_distance].push([node[0] + direction[0], 
                                                    node[1] + direction[1], 
                                                    direction[0], 
                                                    direction[1], 
                                                    3, 
                                                    new_distance])
                end
            end
            if node[0] == input.length - 1 && node[1] == input[node[0]].length - 1 then
                # puts "#{node[7].to_s}"
                part_1_total = node[5] + input[node[0]][node[1]] - input[0][0]
                break
            end
        end
        next_nodes.delete(distance_counter)
        if part_1_total > 0 then
            break
        end
    end
    distance_counter +=1
end

puts part_1_total

visited_nodes = {}
# { heat_loss : [x, y, x_diff, y_diff, straight_line, heat_lost] }
next_nodes = { 0 => [[0, 0, 0, 1, 0, 0, [], []]] }

distance_counter = 0
while next_nodes.length > 0 
    if next_nodes.key? distance_counter then
        while next_nodes[distance_counter].length > 0
            node = next_nodes[distance_counter].pop()
            new_distance = node[5] + input[node[0]][node[1]]
            visitied_node_key = [node[0], node[1], node[2], node[3], node[4]]
            if visited_nodes.key?(visitied_node_key) &&
                visited_nodes[visitied_node_key][0] < new_distance then
                # puts "Skip: #{visitied_node_key} => #{visited_nodes[visitied_node_key]} < #{new_distance}"
                next
            end
            visited_nodes[visitied_node_key] = node[5]
            [[0, 1],[0, -1],[1, 0],[-1, 0]].each do |direction|
                if direction[0] == -1 * node[2] && direction[1] == -1 * node[3] then
                    next # no turning around
                end
                if node[0] + direction [0] < 0 || 
                    node[0] + direction [0] >= input.length || 
                    node[1] + direction [1] < 0 || 
                    node[1] + direction [1] >= input[node[0]].length then
                    # puts "Skip: #{direction.to_s} => #{node.to_s}"
                    next # Off the map
                end
                next_nodes[new_distance] ||= []
                if direction[0] == node[2] && direction[1] == node[3] then
                    if node[4] < 10 then
                        next_nodes[new_distance].push([node[0] + direction[0], 
                                                        node[1] + direction[1], 
                                                        direction[0], 
                                                        direction[1], 
                                                        node[4] + 1, 
                                                        new_distance, 
                                                        node[6] + [[node[0], node[1]]],
                                                        node[7] + [[direction[0], direction[1]]]])
                    end
                else
                    if node[4] > 3 then
                        next_nodes[new_distance].push([node[0] + direction[0], 
                                                        node[1] + direction[1], 
                                                        direction[0], 
                                                        direction[1], 
                                                        1, 
                                                        new_distance, 
                                                        node[6] + [[node[0], node[1]]],
                                                        node[7] + [[direction[0], direction[1]]]])
                    end
                end
            end
            if node[0] == input.length - 1 && node[1] == input[node[0]].length - 1 && node[4] > 3 then
                # puts "#{node[7].to_s}"
                part_2_total = node[5] + input[node[0]][node[1]] - input[0][0]
                break
            end
        end
        next_nodes.delete(distance_counter)
        if part_2_total > 0 then
            break
        end
    end
    distance_counter +=1
end

# visited_nodes.select { |visited_node| visited_node[0] == 11 && visited_node[1] == 12 }.each { |vn| puts vn.to_s }
# puts
# input.each_with_index { |line, x| puts line.each_with_index.map { |val, y| node[6].include?([x,y]) ? "." : val }.join("") }
# puts
# input.each_with_index { |line, x| puts line.each_with_index.map { |val, y| [visited_nodes.select { |visited_node| visited_node[0] == x && visited_node[1] == y }.map{ |vn| vn[1] }.min, val].to_s  }.join("\t") }

puts part_2_total