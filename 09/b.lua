local func   = require "func"
local seq    = require "seq"
local stream = require "stream"

local function extrapolate(xs)
    local diffs = stream.from.list(xs)
        :windows(2)
        :map__u(func.meta.sub:flip())
        :collect(seq)
    return (diffs:all(func.meta.eq:bind(0)))
        and xs[1]
        or  xs[1] - extrapolate(diffs)
end

local sum = 0
for line in io.lines([[input.txt]]) do
    local xs = seq.from.string(line, "%s+"):map(tonumber)
    sum = sum + extrapolate(xs)
end
print(sum)