local func = require "func"
local seq  = require "seq"

local input do
    local f <close> = assert(io.open([[input.txt]]))
    input = f:read("*all")
end

local function hash(str)
    local hash = 0
    for c in str:gmatch(".") do
        hash = (hash + c:byte()) * 17 % 256
    end
    return hash
end

local map = {}
for label, type, focal_len in input:gmatch("(%a+)([=-])(%d*),?") do
    local find_lens = (function(lens) return lens.label == label end)
    local box       = hash(label)
    map[box]        = map[box] or seq {}
    if type == "-" then
        map[box]:removeif(find_lens)
    else
        local found = map[box]:findfirst(find_lens)
        map[box][found or #map[box] + 1] = { 
            label     = label, 
            focal_len = focal_len,
        }
    end
end

local sum = 0
for box, lenses in pairs(map) do
    for i, lens in ipairs(lenses) do
        sum = sum + (box + 1) * i * lens.focal_len
    end
end
print(sum)