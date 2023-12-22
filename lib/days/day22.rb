
def draw_falling_blocks(falling_blocks)
    for z in -9..-1
        for x in 0..2
            draw = falling_blocks.any? { |fallen_block_coord| fallen_block_coord[0][0] <= x && 
                                                                                                fallen_block_coord[1][0] >= x && 
                                                                                                fallen_block_coord[0][2] <= (-1 * z) &&
                                                                                                fallen_block_coord[1][2] >= (-1 * z)}
            print draw ? "#" : "."
        end
        
        print "|" + (-z).to_s + "|"
        
        for y in 0..2
            draw = falling_blocks.any? { |fallen_block_coord| fallen_block_coord[0][1] <= y && 
                                                                                                fallen_block_coord[1][1] >= y && 
                                                                                                fallen_block_coord[0][2] <= (-1 * z) &&
                                                                                                fallen_block_coord[1][2] >= (-1 * z)}
            print draw ? "#" : "."            
        end
        puts
    end
end

part_1_total = 0
part_2_total = 0

blocks = []
tallest = 0
File.foreach("../inputs/day22.txt") do |line| 
    line.chomp()
    start_coords = line.split("~")[0].split(",").map(&:to_i)
    end_coords = line.split("~")[1].split(",").map(&:to_i)

    block_coords = [start_coords, end_coords]
    
    blocks.push(block_coords)
end

blocks = blocks.sort { |a,b| a[0][2] <=> b[0][2]}

falling_blocks = []
# t1 = Time.now
max_height = blocks[0][1][2] + 2
blocks.each do |block_coords|
    still_falling = true
    if block_coords[0][2] > max_height then
        # puts "skip a few falls = #{block_coords[0][2] - max_height}"
        diff = block_coords[0][2] - max_height
        block_coords[0][2] -= diff
        block_coords[1][2] -= diff 
    end
    
    while still_falling
        # Check can fall
        if block_coords[0][2] == 1 || 
            (falling_blocks.reverse.any? { |fallen_block_coords| fallen_block_coords[1][2] == block_coords[0][2] - 1 &&
                                                                    (block_coords[0][0] <= fallen_block_coords[1][0] && 
                                                                    block_coords[1][0] >= fallen_block_coords[0][0]) &&
                                                                    (block_coords[0][1] <= fallen_block_coords[1][1] && 
                                                                    block_coords[1][1] >= fallen_block_coords[0][1]) }) then
            still_falling = false
        end
        if still_falling then
            # puts "Block falling = #{block_coords.to_s}"
            block_coords = block_coords.map { |coord| [coord[0], coord[1], coord[2] - 1] }
        else
            max_height = [max_height, block_coords[1][2]].max + 1
            # puts max_height
        end
    end
    falling_blocks.push(block_coords)
    # puts falling_blocks.to_s
    # draw_falling_blocks(falling_blocks)
    # sleep 1
end
# puts "falling took #{Time.now - t1}s Height = #{max_height - 1}"
# t2 = Time.now

fallen_block_support = {}

falling_blocks.each_with_index do |block_coords, block_index|
    supporting_blocks = falling_blocks.select { |fallen_block_coords| fallen_block_coords[1][2] == block_coords[0][2] - 1 &&
    (block_coords[0][0] <= fallen_block_coords[1][0] && 
    block_coords[1][0] >= fallen_block_coords[0][0]) &&
    (block_coords[0][1] <= fallen_block_coords[1][1] && 
    block_coords[1][1] >= fallen_block_coords[0][1]) }
    .map { |block| falling_blocks.find_index(block) }
    
    # puts "Block #{block_index} (#{block_coords.to_s}) is supported by #{supporting_blocks.map { |id| falling_blocks[id] } }"   
    fallen_block_support[block_index] = supporting_blocks                                                                                    
end

required_blocks = fallen_block_support.values.select { |supporting_blocks| supporting_blocks.length == 1 }.flatten.uniq
# puts required_blocks.to_s
# puts fallen_block_support.to_s
puts falling_blocks.length - required_blocks.length
# puts "Required took #{Time.now - t2}s"

falling_cache = {}

falling_blocks.to_enum.with_index.reverse_each do |block_coords, block_index|
    if !required_blocks.include?(block_index) then
        next
    end
    
    falling_set_length_previously = 0
    falling_set = [block_index]
    about_to_fall = []
    while falling_set.length != falling_set_length_previously
        # puts falling_set.to_s
        # sleep 1
        falling_set_length_previously = falling_set.length 
        about_to_fall = fallen_block_support.select do |id, supporting_blocks|
            supporting_blocks != [] &&
            !falling_set.include?(id) &&
            (supporting_blocks - falling_set).empty?
        end.keys
        if about_to_fall.length == 1 && falling_cache.key?(about_to_fall[0]) then
            break
        end
        falling_set += about_to_fall
    end
    output = falling_set.length - 1
    if about_to_fall.length == 1 && falling_cache.key?(about_to_fall[0]) then
        # puts "Cache found for #{about_to_fall.to_s}"
        output += falling_cache[about_to_fall[0]] + 1
    end
    falling_cache[block_index] = output
    
    # puts "#{block_index} eliminated makes #{output} fall - #{falling_set[0..10].to_s} + cached from #{about_to_fall[0]}"
    part_2_total += output
end
# puts falling_cache.to_s
puts part_2_total