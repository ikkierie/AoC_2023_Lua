local func = require "func"
local seq  = require "seq"

local cards = {}
for line in io.lines([[input.txt]]) do
    
    local id, win_str, pool_str = line:match("Card%s+(%d+)%s*:%s+([^|]+)|(.+)$")

    local wins = seq.from.string(win_str,  "%s+"):map(tonumber)
    local pool = seq.from.string(pool_str, "%s+"):map(tonumber)

    id        = tonumber(id)
    cards[id] = (cards[id] or 0) + 1

    local winners = #pool:where(seq.contains:bind(wins))
    for _ = 1, cards[id] do
        for i = id + 1, id + winners do
            cards[i] = (cards[i] or 0) + 1
        end
    end

end

print(seq.from.values(cards):sum())