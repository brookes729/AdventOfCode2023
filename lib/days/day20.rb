broadcaster_out = []
flip_flops = {}
conjuctions = {}

part_1_total = 0
part_2_total = 0

File.foreach("../inputs/day20.txt") do |line| 
    line_details = line.chomp().split(" -> ")
    type = line_details[0][0]

    if type == "b" then
        broadcaster_out = line_details[1].split(", ")
    elsif type == "%" then
        flip_flops[line_details[0][1..-1]] = [line_details[1].split(", "), false]
    elsif type == "&" then
        conjuctions[line_details[0][1..-1]] = [line_details[1].split(", "), {}]
    end
end

conjuctions.each do |conjuction|
    flip_flops.each do |flip_flop|
        if flip_flop[1][0].include?(conjuction[0]) then
            conjuction[1][1][flip_flop[0]] = false
        end
    end
    conjuctions.each do |other_conj|
        if other_conj[1][0].include?(conjuction[0]) then
            conjuction[1][1][other_conj[0]] = false
        end
    end
end

rx_dep = ""

conjuctions.each do |conj|
    if conj[1][0].include?("rx") then
        rx_dep = conj[0]
        break
    end
end

# puts rx_dep
rx_dep_dep = []

flip_flops.each do |flip_flop|
    if flip_flop[1][0].include?(rx_dep) then
        rx_dep_dep.push(flip_flop[0])
    end
end
conjuctions.each do |conj|
    if conj[1][0].include?(rx_dep) then
        rx_dep_dep.push(conj[0])
    end
end


states = {broadcaster_out.to_s + flip_flops.to_s + conjuctions.to_s => [0, 0,0]}
low_pulse_count = 0
high_pulse_count = 0
x = 0
rx_dep_dep_cycle = {}
while x <= 1000 || (rx_dep != "" && part_2_total == 0)
    x += 1
    if x % 10000 == 0 then
        puts "button press #{x}"
    end
    pulse_list = [["broadcaster", false, "button"]]
    
    while pulse_list.length > 0
        pulse = pulse_list.shift()
        # puts "#{pulse[2]} -#{pulse[1] ? "high" : "low"}-> #{pulse[0]}"
        low_pulse_count += !pulse[1] ? 1 : 0
        high_pulse_count += pulse[1] ? 1 : 0

        if pulse[0] == rx_dep && pulse[1] then
            rx_dep_dep_cycle[pulse[2]] = x
            if rx_dep_dep_cycle.length == rx_dep_dep.length then
                part_2_total = rx_dep_dep_cycle.values.inject(:*)
            end
        end
        
        if pulse[0] == "broadcaster" then
            broadcaster_out.each do |out|
                pulse_list.push([out, pulse[1], pulse[0]])
            end
        elsif flip_flops.key?(pulse[0]) && !pulse[1] then
            flip_flops[pulse[0]][0].each do |destination|              
                pulse_list.push([destination, !flip_flops[pulse[0]][1], pulse[0]])
            end
            flip_flops[pulse[0]][1] = !flip_flops[pulse[0]][1]
            # puts flip_flops.to_s
        elsif conjuctions.key?(pulse[0]) then
            conjuctions[pulse[0]][1][pulse[2]] = pulse[1]
            # puts conjuctions.to_s
            conjuctions[pulse[0]][0].each do |destination|
                pulse_list.push([destination, !conjuctions[pulse[0]][1].all? { |store| store[1] }, pulse[0]])
            end
        end
    end  
    if x == 1000 then
        # puts [low_pulse_count,  high_pulse_count].to_s
        puts low_pulse_count * high_pulse_count
    end
end
puts part_2_total