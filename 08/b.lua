local prime  = require "prime"
local seq    = require "seq"
local stream = require "stream"

local directions, map do
    local f <close>  = assert(io.open([[input.txt]]))
    directions = f:read("*l", "*l")
    map        = {}
    for line in f:lines() do
        local src, l, r = line:match("(%w+)%s*=%s*%((%w+),%s*(%w+)%)")
        map[src] = { L = l, R = r }
    end
end

local paths = stream.from.keys(map)
    :where(function(x) return x:match("A$") end)
    :collect(seq)

for i, pos in ipairs(paths) do
    local n_steps = 0
    for direction in stream.from.string(directions):rep() do
        if pos:match("Z$") then
            break
        end
        pos = map[pos][direction]
        n_steps = n_steps + 1
    end
    paths[i] = n_steps
end

print(paths
    :map(prime.factors)
    :reduce(function(x, y) return x | y end)
    .n
)