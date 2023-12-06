part_1_total = 1
part_2_total = 0

input = File.readlines("../inputs/day6.txt")

times = input[0].split(":")[1].split.map(&:chomp).map(&:to_i)
distance = input[1].split(":")[1].split.map(&:chomp).map(&:to_i)

puts times.to_s
puts distance.to_s

for x in 0..times.length-1
    win_count = 0
    for testnumber in 0..times[x] 
        if (times[x] - testnumber) * testnumber > distance[x] then
            win_count += 1
        end
    end
    puts win_count
    part_1_total *= win_count
end

t1=Time.now
win_count = 0
for testnumber in 0..times.join.to_i
    if (times.join.to_i - testnumber) * testnumber > distance.join.to_i then
        win_count += 1
    end
end
t2 = Time.now
puts t2-t1

puts part_1_total
puts win_count