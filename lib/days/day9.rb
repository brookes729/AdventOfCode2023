def find_next_value(input)
    if input.all?(0) then
        return [0,0]
    end

    differences = []
    for x in 0..(input.length - 2) do
        differences.push(input[x+1] - input[x])
    end
    next_values = find_next_value(differences)
    #puts "in #{input.to_s} next #{find_next_value(differences).to_s}"
    return [input[0] - next_values[0], input[-1] + next_values[1]]
end


input = File.readlines("../inputs/day9.txt").map(&:chomp).map(&:split).map { |arr| find_next_value(arr.map(&:to_i)) }

puts input.inject { |sum, n| [sum[0] + n[0],sum[1]+ n[1]] }.to_s
