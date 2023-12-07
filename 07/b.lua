local func   = require "func"
local seq    = require "seq"
local stream = require "stream"

local cards = seq.from.string("AKQT98765432J"):reverse()

local function kind(hand)
    local hand     = seq.from.string(hand)
    local counts   = hand
        :distinct()
        :where(function(x) return x ~= "J" end)
        :sort_by(seq.count:bind(hand))
    hand:apply(function(x)
        return (x == "J")
            and counts[#counts]
            or  x
    end)
    local distinct = hand:distinct()
    if #distinct == 1 then
        return 5
    elseif #distinct == 2 then
        if math.max(hand:count(distinct[1]), hand:count(distinct[2])) == 4 then
            return 4
        else
            return 3.5
        end
    elseif #distinct == 3 then
        if distinct:map(seq.count:bind(hand)):reduce(math.max) == 3 then
            return 3
        else
            return 2.5
        end
    elseif #distinct == 4 then
        return 2
    else
        return 1
    end
end

local function kicker(hand)
    return stream.from.string(hand)
        :enumerate(4, -1)
        :map__u(function(i, x) 
            return 16^i * cards:contains(x)
        end)
        :sum()
end

local pool = seq {}
for line in io.lines([[input.txt]]) do
    local hand, bet = line:match("(%S+)%s+(%S+)")
    pool:insert { 
        hand = hand, 
        bet  = tonumber(bet)
    }
end

pool:sort_by(function(x)
    return kind(x.hand) * 16^6 + kicker(x.hand)
end)

print(
    stream.from.list(pool)
        :map_field("bet")
        :enumerate()
        :map(seq.product)
        :sum()
) 