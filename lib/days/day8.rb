directions_index = ["L","R"]

part_2_start = []

directions = File.readlines("../inputs/day8.txt")[0].chomp().split(//)
nodes = {}
File.readlines("../inputs/day8.txt")[2..-1].map(&:chomp).each do |line|
    node_matches = line.match(/\(([0-9A-Z]{3}), ([0-9A-Z]{3})/)
    nodes[line.split(" = ")[0]] = node_matches.captures
    if line.split(" = ")[0][2] == "A" then
        part_2_start.push(line.split(" = ")[0])
    end
end

current_node = "AAA"
step = 0
count = 0
while current_node != "ZZZ" do
    current_node = nodes[current_node][directions_index.find_index(directions[step])]
    #puts current_node
    if step == directions.length - 1 then
        step = 0
    else
        step += 1
    end
    count += 1
end

puts count

step = 0
count = 0
node_found = {}
while part_2_start.length > 0 do
    next_nodes = []
    part_2_start.each do |node|
        new_node = nodes[node][directions_index.find_index(directions[step])]
        if new_node[2] != "Z" 
            next_nodes.push(new_node)
        else
            node_found[new_node] = count + 1
        end
    end
    part_2_start = next_nodes
    #puts part_2_start.to_s

    if step == directions.length - 1 then
        step = 0
    else
        step += 1
    end
    count += 1
end

puts node_found.map { |node| node[1] }.reduce(1, :lcm)