part_1_total = 0
part_2_total = 0
boxes = {}
File.read("../inputs/day15.txt").split(",") do |section| 
    current_value = 0
    section.each_byte do |ascii|
        current_value += ascii
        current_value *= 17
        current_value %= 256
    end
    # puts "#{section} => #{current_value}"
    part_1_total += current_value

    if section =~ /\=/ then
        label = section.split(/\=/)[0]
        focal = section.split(/\=/)[1].to_i
        box = 0
        label.each_byte do |ascii|
            box += ascii
            box *= 17
            box %= 256
        end
        if (boxes.key? box) && (boxes[box].any? { |lens| lens[0] == label }) then
            boxes[box] = boxes[box].map do |lens|
                if lens[0] == label then
                    [lens[0], focal]
                else
                    lens
                end
            end
        else
            if boxes.key? box then
                boxes[box] = boxes[box] + [[label, focal]] 
            else
                boxes[box] = [[label, focal]]
            end
        end
    elsif section =~ /\-/ then
        label = section.split(/\-/)[0]
        box = 0
        label.each_byte do |ascii|
            box += ascii
            box *= 17
            box %= 256
        end
        boxes[box] = (boxes.key? box) ? boxes[box].select { |lens| lens[0] != label } : []
    end
end

# puts boxes.to_s
boxes.each do |box|
    counter = 0
    box[1].each do |lens|
        counter += 1
        part_2_total += (box[0] + 1) * counter * lens[1]
    end
end

puts part_1_total
puts part_2_total