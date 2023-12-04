local func = require "func"
local seq  = require "seq"

local sum = 0
for line in io.lines([[input.txt]]) do
    local winning, pool = line:match(":%s+([^|]+)|(.+)$")
    local win = seq.from.string(winning, "%s+"):map(tonumber)
    local n = #seq.from.string(pool, "%s+")
        :map(tonumber)
        :where(seq.contains:bind(win))
    sum = sum + math.tointeger((n == 0) and 0 or 2^(n - 1))
end
print(sum)