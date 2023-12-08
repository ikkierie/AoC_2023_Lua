local stream = require "stream"

local directions, map do
    local f <close> = assert(io.open([[input.txt]]))
    directions = f:read("*l", "*l")
    map        = {}
    for line in f:lines() do
        local src, l, r = line:match("(%w+)%s*=%s*%((%w+),%s*(%w+)%)")
        map[src] = { L = l, R = r }
    end
end

local pos  = "AAA"
local goal = "ZZZ"

local n_steps = 0
for direction in stream.from.string(directions):rep() do
    if pos == goal then
        break
    end
    pos     = map[pos][direction]
    n_steps = n_steps + 1
end
print(n_steps)