def build_and_test(test_string, inputs, cache)
    if cache.key?(test_string.join + inputs.join(",")) then
        return cache[test_string.join + inputs.join(",")]
    end

    count = 0
    if inputs == [] then
        if !test_string.include?("#") then
            # puts "Last val remaining: #{test_string.join}"
            return 1
        end
        return 0
    end
    
    test_length = test_string.length
    inputs_length = inputs[1..-1].sum + inputs.count - 2
        
    potential = "#" * inputs[0] 
    if inputs.length > 1 then
        potential += "."
    end
    while potential.length + inputs_length <= test_length
        # puts "#{potential} against "
        # puts "#{test_string[0..potential.length-1].join}"
        matched = true
        potential.chars.each_with_index do |char, index|
            if test_string[index] != "?" && char != test_string[index] then
                matched = false
            end
        end
        if matched then
            # puts "Matched - test #{test_string[potential.length..-1]}, #{inputs[1..-1]}"
            count += build_and_test(test_string[potential.length..-1], inputs[1..-1], cache)
        end
        potential = "." + potential
    end
    # puts "#{test_string.join}, #{inputs} => #{potential} #{count}"
    cache[test_string.join + inputs.join(",")] = count
    return count
end

part_1_total = 0
part_2_total = 0

input = File.readlines("../inputs/day12.txt").map(&:chomp).map {|line| line.split(/ /)}.map { |section| [section[0].split(//), section[1].split(/,/).map(&:to_i)] }

t1 = Time.now
input.each do |line|
    cache = {}
    potentials = build_and_test(line[0], line[1], cache)
    part_1_total += potentials

    quin_seed = line[0] + ["?"] + line[0] + ["?"] + line[0] + ["?"] + line[0] + ["?"] + line[0]
    quin_target = line[1] + line[1] + line[1] + line[1] + line[1]
    potentials5 = build_and_test(quin_seed, quin_target, cache)
    part_2_total += potentials5
    #puts "#{line[0].join} t= #{Time.now - t1} \t#{potentials5} "
end
puts Time.now - t1
puts part_1_total
puts part_2_total