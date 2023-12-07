card_order = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
card_order2 = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

def find_hand(card, type)
    card_count = count_cards(card[0], type)
    #puts card_count.to_s
    type = 0
    # 5 of a kind = 7
    if card_count == [5] then
        type = 7
    # 4 of a kind = 6
    elsif card_count == [4] then
        type = 6
    # full house 3 of a kind & 2 of a kind = 5
    elsif card_count == [3, 2] || card_count == [2, 3] then
        type = 5
    # 3 of a kind = 4
    elsif card_count == [3] then
        type = 4
    # 2 pairs = 3
    elsif card_count == [2, 2] then
        type = 3
    # 1 pair = 2
    elsif card_count == [2] then
        type = 2
    # else = 1
    else
        type = 1
    end
    return [type, card[0], card[1]]
end

def count_cards(card, type)
    output = {}
    card.chars do |char|
        output[char] ||= 0
        output[char] += 1 
    end
    if type == 2 then
        jacks = output["J"] || 0
        if jacks != 5 then
            output = output.select { |card| card != "J" }.sort_by {|card| -card[1] }
            output[0][1] += jacks
        else 
            output["J"] = 5
        end
    end

    return output.map { |counts| counts[1]}.select { |count| count > 1 }
end

part_1_total = 1
part_2_total = 0

input = File.readlines("../inputs/day7.txt")
        .map(&:split)
        .map { |card| find_hand(card,1) }
        .sort_by { |hand| [hand[0], 
                            -card_order.find_index(hand[1][0]), 
                            -card_order.find_index(hand[1][1]), 
                            -card_order.find_index(hand[1][2]), 
                            -card_order.find_index(hand[1][3]), 
                            -card_order.find_index(hand[1][4])]}
        .each_with_index.map { |value, index| [index + 1, value] }


# input.each do |card|
#   puts "#{card[1][1]} is \trank #{card[0]} \t type #{card[1][0]} bid \t#{card[1][2]} \t#{card[0].to_i * card[1][2].to_i}"
# end
puts input.map { |card| card[0].to_i * card[1][2].to_i }.sum
# Part 2
input = File.readlines("../inputs/day7.txt")
        .map(&:split)
        .map { |card| find_hand(card,2) }
        .sort_by { |hand| [hand[0], 
                            -card_order2.find_index(hand[1][0]), 
                            -card_order2.find_index(hand[1][1]), 
                            -card_order2.find_index(hand[1][2]), 
                            -card_order2.find_index(hand[1][3]), 
                            -card_order2.find_index(hand[1][4])]}
        .each_with_index.map { |value, index| [index + 1, value] }


# input.each do |card|
#   puts "#{card[1][1]} is \trank #{card[0]} \t type #{card[1][0]} bid \t#{card[1][2]} \t#{card[0].to_i * card[1][2].to_i}"
# end
puts input.map { |card| card[0].to_i * card[1][2].to_i }.sum