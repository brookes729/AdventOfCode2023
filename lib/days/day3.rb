def check_directions_get_value(map, a, b, already_counted)
    output = 0
    for a_offset in -1..1 do
        for b_offset in -1..1 do
            output += get_value(map, a + a_offset, b + b_offset, already_counted) # central value is always 0 no need to exclude
        end
    end

    return output
end

def check_directions_get_gears(map, a, b)
    output = 1
    ratio_count = 0
    already_counted = []
    for a_offset in -1..1 do
        for b_offset in -1..1 do
            value = get_value(map, a + a_offset, b + b_offset, already_counted) 
            if value != 0 then
                output *= value
                ratio_count += 1
            end
        end
    end
    #puts "#{a},#{b} - ratio #{ratio_count} gives #{output}"
    return ratio_count == 2 ? output : 0
end

def get_value(map, a, b, already_counted)
    if map[a][b] !~ /\d/ then
        return 0
    end

    output_array = [map[a][b]]
    tmp_b = b
    while tmp_b > 0 do
        if map[a][tmp_b-1] !~ /\d/ then
            break
        end
        output_array.unshift(map[a][tmp_b-1])
        tmp_b -= 1
    end

    # record the first value to avoid duplication
    if already_counted.include? [a,tmp_b] then
        return 0
    else 
        already_counted.push([a,tmp_b])
    end

    tmp_b = b
    while tmp_b < map[a].length do
        if map[a][tmp_b+1] !~ /\d/ then
            break
        end
        output_array.push(map[a][tmp_b+1])
        tmp_b += 1
    end

    return output_array.join.to_i
end

part_1_total = 0
part_2_total = 0


part_1_map = File.readlines("../inputs/day3.txt").map(&:chomp).map(&:chars)

already_counted = []

for a in 0..(part_1_map.length - 1) do
    for b in 0..(part_1_map[a].length - 1) do
        if part_1_map[a][b] !~ /[\.\d]/ then
            #puts part_1_map[a][b]
            part_1_total += check_directions_get_value(part_1_map, a, b, already_counted)
        end
        if part_1_map[a][b] =~ /\*/ then
            #puts part_1_map[a][b]
            part_2_total += check_directions_get_gears(part_1_map, a, b)
        end
    end
end

puts part_1_total
puts part_2_total