def assess_rule(rules, xmas_order, current_rule, remaining_values)
    output = 0
    # puts current_rule.to_s
    rules[current_rule].each do |rule|
        if rule == "A" then
            output += (remaining_values[1] - remaining_values[0] - 1) *
            (remaining_values[3] - remaining_values[2] - 1) *
            (remaining_values[5] - remaining_values[4] - 1) *
            (remaining_values[7] - remaining_values[6] - 1)
            # puts "A => #{remaining_values.to_s} => #{output}"
        elsif rule == "R" then
            reject = (remaining_values[1] - remaining_values[0] - 1) *
            (remaining_values[3] - remaining_values[2] - 1) *
            (remaining_values[5] - remaining_values[4] - 1) *
            (remaining_values[7] - remaining_values[6] - 1)
            # output += reject # test if totals are right
            # puts "R => #{remaining_values.to_s} => #{reject}"
        elsif !rule.include?(":") then
            output += assess_rule(rules, xmas_order, rule, remaining_values)
        elsif rule.include?("<") then
            check = rule.split(":")
            applied_to = xmas_order[check[0].split("<")[0]]
            compare_to = check[0].split("<")[1].to_i

            # puts "#{check[0].split("<")[0]} < #{compare_to} - Current min #{remaining_values[applied_to*2]} max #{remaining_values[applied_to*2 + 1]}"
            next_rule_values = remaining_values.clone
            next_rule_values[applied_to*2 + 1] = compare_to 
            output += assess_rule(rules, xmas_order, check[1], next_rule_values)
            remaining_values[applied_to*2] = compare_to - 1
        elsif rule.include?(">") then
            check = rule.split(":")
            applied_to = xmas_order[check[0].split(">")[0]]
            compare_to = check[0].split(">")[1].to_i

            # puts "#{check[0].split(">")[0]} > #{compare_to} - Current min #{remaining_values[applied_to*2]} max #{remaining_values[applied_to*2 + 1]}"
            next_rule_values = remaining_values.clone
            next_rule_values[applied_to*2] = compare_to 
            output += assess_rule(rules, xmas_order, check[1], next_rule_values)
            remaining_values[applied_to*2 + 1] = compare_to + 1
        else
            puts "Rule issue! #{rule}"
        end
    end
    return output
end

xmas_order = {
    "x" => 0,
    "m" => 1,
    "a" => 2,
    "s" => 3
}

rules = {
    "A" => ["A"],
    "R" => ["R"]
}
found_ratings = false

part_1_total = 0
part_2_total = 0
File.foreach("../inputs/day19.txt") do |line| 
    line = line.chomp()
    if line == "" then
        found_ratings = true
        next
    end
    if !found_ratings then
        rule_name = line.split("{")[0]
        rule_instructions = line.split("{")[1][0..-2].split(",")
        rules[rule_name] = rule_instructions
    else 
        rule_sorted = false
        xmas = line[1..-2].split(",").map { |val| val.split("=")[1].to_i }
        current_rule = "in"
        # puts xmas.to_s
        while !rule_sorted
            # puts rules[current_rule].to_s
            rules[current_rule].each do |rule|
                # puts rule.to_s
                if rule == "A" then
                    rule_sorted = true
                    part_1_total += xmas.sum()
                    break
                elsif rule == "R" then
                    rule_sorted = true
                    break
                elsif !rule.include?(":") then
                    current_rule = rule
                    break
                elsif rule.include?("<") then
                    check = rule.split(":")
                    applied_to = xmas_order[check[0].split("<")[0]]
                    compare_to = check[0].split("<")[1].to_i
                    if xmas[applied_to] < compare_to then
                        current_rule = check[1]
                        break
                    end
                elsif rule.include?(">") then
                    check = rule.split(":")
                    applied_to = xmas_order[check[0].split(">")[0]]
                    compare_to = check[0].split(">")[1].to_i
                    if xmas[applied_to] > compare_to then
                        current_rule = check[1]
                        break
                    end
                else
                    puts "Rule issue! #{rule}"
                end
            end
        end
        
    end
end

# puts rules.to_s
puts part_1_total
puts assess_rule(rules, xmas_order, "in", [0, 4001, 0, 4001, 0, 4001, 0, 4001]) 