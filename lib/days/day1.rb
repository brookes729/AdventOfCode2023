text_to_numbers = { "one" => 1, "two" => 2, "three" => 3,
                    "four" => 4, "five" => 5, "six" => 6,
                    "seven" => 7, "eight" => 8, "nine" => 9,
                    "1" => 1, "2" => 2, "3" => 3,
                    "4" => 4, "5" => 5, "6" => 6,
                    "7" => 7, "8" => 8, "9" => 9
                }

part_1_total = 0
part_2_total = 0
File.foreach("../inputs/day1.txt") do |line| 
    numbers = line.scan(/\d+/) 
    coords = numbers[0][0] + numbers[-1][-1]
    part_1_total += coords.to_i()

    text = line.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|\d))/) 
    coords = text_to_numbers[text[0][0]].to_s() + text_to_numbers[text[-1][0]].to_s()
    part_2_total += coords.to_i()
end

puts part_1_total
puts part_2_total