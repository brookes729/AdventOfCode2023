def play_card(outcomes, card, card_cache)
    if card_cache.key?(card) then 
        return card_cache[card]
    end

    outcome = 1 # current card
    for x in 1..outcomes[card] do
        outcome += play_card(outcomes, card + x, card_cache)
    end

    card_cache[card] = outcome

    return outcome
end
    
part_1_total = 0
part_2_total = 0
part_2_outcomes = {}

File.foreach("../inputs/day4.txt") do |line| 
    line_details = line.split(/: /)
    game_id = line_details[0].split("Card ")[1].to_i
    winning = line_details[1].split("|")[0].split().map(&:chomp).map(&:to_i)
    
    got = line_details[1].split("|")[1].split().map(&:chomp).map(&:to_i)

    matches = winning & got

    if matches.length > 0 then
        part_1_total += 2 ** (matches.length - 1)
    end

    part_2_outcomes[game_id] = matches.length
end

part_2_outcomes.each{ |card| part_2_total += play_card(part_2_outcomes, card[0], {})}

puts part_1_total
puts part_2_total