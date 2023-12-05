def map_input(input, start_string, output)
    found_start = false
    input.each do |line|
        if found_start then
            if line == "" then
                break
            end
            output.push(line.scan(/\d+/).map(&:to_i))
        else 
            if line == start_string
                found_start = true
            end
        end
    end
end

def follow_map(starting_point, map)
    map.each do |range|
        if starting_point >= range[1] && starting_point < range[1] + range[2]
            difference = starting_point - range[1]
            return range[0] + difference
        end
    end
    return starting_point
end

def follow_map_for_range(starting_ranges, map)
    mapped_ranges = []

    map.each do |a|
        unmapped_ranges = []
        starting_ranges.each do |x| 
            # comparing starting range x -> y => x[0] -> x[0] + x[1] - 1
            # to mapping ranges a -> b => a[1] -> a[1] + a[2] - 1 mapping to (x[0] + a[0] - a[1], a2)
            if  a[1] + a[2] - 1 < x[0] || x[0] + x[1] - 1 < a[1] then
                # a - b < x - y or x - y < a - b
                unmapped_ranges.push(x)
                #puts "1: "+ x.to_s + " - " + a.to_s + " => " + (mapped_ranges | starting_ranges).to_s
            elsif a[1] < x[0] && x[0] <= a[1] + a[2] - 1 && a[1] + a[2] - 1 < x[0] + x[1] - 1 then
                # a < x < b < y
                mapped_ranges.push([x[0]+a[0]-a[1], a[1] + a[2] - x[0]]) # x-b mapped
                unmapped_ranges.push([a[1] + a[2], x[1] - (a[1] + a[2] - x[0])]) # b-y unmapped
                #puts "2: "+ x.to_s + " - " + a.to_s + " => " + (mapped_ranges | starting_ranges).to_s
            elsif x[0] <= a[1] &&  a[1] + a[2] - 1 <= x[0] + x[1] - 1 then
                # x < a - b < y
                unmapped_ranges.push([x[0], a[1] - x[0]]) # x-a unmapped
                mapped_ranges.push([a[0], a[2]]) # a-b mapped
                unmapped_ranges.push([a[1] + a[2], x[0] + x[1] - (a[1] + a[2])]) # b-y unmapped
                #puts "3: "+ x.to_s + " - " + a.to_s + " => " + (mapped_ranges | starting_ranges).to_s
            elsif x[0] < a[1] && a[1] <= x[0] + x[1] - 1 &&  x[0] + x[1] - 1 < a[1] + a[2] - 1 then
                # x < a < y < b
                unmapped_ranges.push([x[0], a[1] - x[0]]) # x-a unmapped
                mapped_ranges.push([a[0], x[1] + x[0] - a[1]]) # a-y mapped
                #puts "4: "+ x.to_s + " - " + a.to_s + " => " + (mapped_ranges | starting_ranges).to_s
            elsif a[1] <= x[0] && x[0] + x[1] - 1 <= a[1] + a[2] - 1 then
                # a < x - y < b
                mapped_ranges.push([x[0]+a[0]-a[1], x[1]]) # x-y mapped
                #puts "5: "+ x.to_s + " - " + a.to_s + " => " + (mapped_ranges | starting_ranges).to_s
            else
                # shouldn't get hit
                #puts "?: "+ x.to_s + " - " + a.to_s
                unmapped_ranges.push(x)

            end
        end
        starting_ranges = unmapped_ranges
    end
    #puts (mapped_ranges | starting_ranges).to_s
    return (mapped_ranges | starting_ranges).select { |range| range[1] !=0  }
end

part_1_total = 0
part_2_total = 0

seeds = []
seed_soil = []
soil_fertilizer = []
fertilizer_water = []
water_light = []
light_temperature = []
temperature_humidity = []
humidity_location = []

input_lines = File.foreach("../inputs/day5.txt").map(&:chomp)

seeds = input_lines[0].scan(/\d+/).map(&:to_i)
map_input(input_lines, "seed-to-soil map:", seed_soil)
map_input(input_lines, "soil-to-fertilizer map:", soil_fertilizer)
map_input(input_lines, "fertilizer-to-water map:", fertilizer_water)
map_input(input_lines, "water-to-light map:", water_light)
map_input(input_lines, "light-to-temperature map:", light_temperature)
map_input(input_lines, "temperature-to-humidity map:", temperature_humidity)
map_input(input_lines, "humidity-to-location map:", humidity_location)

location = []
seeds.each do |seed|
    location.push(
        follow_map(
            follow_map(
                follow_map(
                    follow_map(
                        follow_map(
                            follow_map(
                                follow_map(seed, seed_soil), soil_fertilizer), fertilizer_water), water_light), light_temperature), temperature_humidity), humidity_location))
end


puts location.min


seed_ranges = seeds.each_slice(2).to_a 
location_ranges =  follow_map_for_range(
    follow_map_for_range(
        follow_map_for_range(
            follow_map_for_range(
                follow_map_for_range(
                    follow_map_for_range(
                        follow_map_for_range(seed_ranges, seed_soil), soil_fertilizer), fertilizer_water), water_light), light_temperature), temperature_humidity), humidity_location)
#puts location_ranges.to_s

puts location_ranges.map { |range| range[0] }.min