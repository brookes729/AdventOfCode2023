def traverse_from_node(map, starting_node, ending_node)
    nodes = [starting_node]
    visited = []

    paths = []

    while nodes.length > 0
        current_pos = nodes.pop
        # puts current_pos.to_s
        visited.push(current_pos)
        if current_pos == ending_node then
            next
        end
        [[1, 0, "v"], [-1, 0, "^"], [0, 1, ">"], [0, -1, "<"]].each do |direction|
            if map[current_pos[0] + direction[0]][current_pos[1] + direction[1]] == direction[2] then
                next_path = explore_path(map, [current_pos[0] + (2 * direction[0]), current_pos[1] + (2 * direction[1])])
                paths.push([current_pos] + next_path)
                if !visited.include?(next_path[1]) && !nodes.include?(next_path[1]) then
                    nodes.push(next_path[1])
                end
            end
        end
    end
    return [visited, paths]
end

def explore_path(map, current_pos)
    visited_positions = []
    next_node = [0,0]
    while next_node == [0,0]
        # puts current_pos.to_s
        # puts visited_positions.to_s
        [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |direction|
            # puts "#{direction} => #{map[current_pos[0] + direction[0]][current_pos[1] + direction[1]].to_s}"
            if map[current_pos[0] + direction[0]][current_pos[1] + direction[1]] == "." then
                # Found a path - if we've not been there before move to it
                if visited_positions.include?([current_pos[0] + direction[0], current_pos[1] + direction[1]]) then
                    next
                end
                visited_positions.push(current_pos)
                current_pos = [current_pos[0] + direction[0], current_pos[1] + direction[1]]
                break
            elsif direction == [1, 0] &&
                map[current_pos[0] + direction[0]][current_pos[1] + direction[1]] == "v" then
                next_node = [current_pos[0] + 2, current_pos[1]]
                break
            elsif direction == [-1, 0] &&
                map[current_pos[0] + direction[0]][current_pos[1] + direction[1]] == "^" then
                next_node = [current_pos[0] - 2, current_pos[1]]
                break
            elsif direction == [0, 1] &&
                map[current_pos[0] + direction[0]][current_pos[1] + direction[1]] == ">" then
                next_node = [current_pos[0], current_pos[1] + 2]
                break
            elsif direction == [0, -1] &&
                map[current_pos[0] + direction[0]][current_pos[1] + direction[1]] == "<" then
                next_node = [current_pos[0], current_pos[1] - 2]
                break
            end
        end
        # sleep 1
    end
    # + 1 for skipped start + 3 for skipped end (not added to visited)
    return [visited_positions.length + 1 + 3, next_node]
end

completed_nodes = []
starting_node = [-1,1]

part_1_total = 0
part_2_total = 0

map = File.readlines("../inputs/day23.txt")
            .map(&:chomp)
            .map {|line| line.split(//)}

ending_node = [map.length, map[0].length - 2]
# Creating pretend slopes will help to map and wont alter the output
map[0][1] = "v"
map[map.length-1][map[0].length - 2] = "v"
current_pos = [1,1]

all_nodes, paths = traverse_from_node(map, starting_node, ending_node)

# paths.each { |path| puts "#{all_nodes.find_index(path[0])} -#{path[1]}-> #{all_nodes.find_index(path[2])} " }

nodes = [[starting_node,[], 0]]
completed_paths = []

while nodes.length > 0
    current_node = nodes.pop
    current_node[1] = current_node[1] + [current_node[0]]
    possible_paths = paths.select { |path| path[0] == current_node[0] && !current_node[1].include?(path[2]) }
    
    possible_paths.each do |path|
        if path[2] == ending_node then
            completed_paths.push(current_node[2] + path[1])
        else
            nodes.push([path[2], current_node[1], current_node[2] + path[1]])
        end
    end
end

# puts completed_paths.to_s
# Remove 2 for the fact we invented nodes off the map to make this work 
puts completed_paths.max() - 2

nodes = [[starting_node,[], 0, {}]]
tested_nodes = 0

while nodes.length > 0
    tested_nodes +=1
    current_node = nodes.pop
    current_node[1] = current_node[1] + [current_node[0]]
    possible_paths = paths.select { |path| path[0] == current_node[0] && !current_node[1].include?(path[2]) }
    possible_paths += paths.select { |path| path[2] == current_node[0] && !current_node[1].include?(path[0]) }.map { |path| [path[2],path[1],path[0]] }
    
    # puts current_node.to_s
    # puts possible_paths.to_s
    # puts "\e[H\e[2J" # console clear
    # puts "via #{current_node[1].map { |node| all_nodes.find_index(node) }.join(">")}"
    
    possible_paths.each do |path|
        # puts "#{current_node[2]} (#{all_nodes.find_index(path[0])}) -#{path[1]}-> #{path[2]} (#{all_nodes.find_index(path[2])}) "
        if path[2] == ending_node then
            if part_2_total < current_node[2] + path[1] then
                part_2_total = current_node[2] + path[1]
                puts tested_nodes
                puts "max = #{part_2_total}" # output it as it goes to show its doing something...
            end
            break # Only one route to the end, can't beat that
        else
            nodes.push([path[2], current_node[1], current_node[2] + path[1]])
        end
    end
end

puts tested_nodes
# Remove 2 for the fact we invented nodes off the map to make this work 
puts part_2_total - 2