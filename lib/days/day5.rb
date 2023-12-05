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
    new_ranges = []
    starting_ranges.each do |starting_range| 
        map.each do |map_range|
            if starting_range[0] + starting_range[1] < map_range[1] || map_range[1] + map_range[2] < starting_range[0] then
                # mapped range is lower than start of starting range so doesn't impact 
                next
            elsif starting_range[0] < map_range[1] && starting_range[0] + starting_range[1] < map_range[1] + map_range[2] then
                # mapped range is overlapping one end
                puts "1: "+ starting_range.to_s + " - " + map_range.to_s
            # elsif map_range[1] < starting_range[0] &&  map_range[1] + map_range[2] > starting_range[0]then
            #     # mapped range is overlapping one end
            #     puts "2: "+ starting_range.to_s + " - " + map_range.to_s
            # else
            #     # mapped range is fully overlapping 
            #     puts "3: "+ starting_range.to_s + " - " + map_range.to_s

            end
        end
    end
    return new_ranges
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
soil_ranges = follow_map_for_range(seed_ranges, seed_soil)
puts soil_ranges.to_s