local deq    = require "deq"
local point  = require "point"
local stream = require "stream"

local directions = {
    U = point {  0, -1 },
    D = point {  0,  1 },
    L = point { -1,  0 },
    R = point {  1,  0 },
}

local turn = {
    U = { "L", "R" },
    D = { "R", "L" },
    L = { "D", "U" },
    R = { "U", "D" },
}

local pos   = point { 0, 0 }
local loop  = { [pos] = true }
local sides = { {}, {} }
for line in io.lines([[input.txt]]) do
    local dir, n, col = line:match("(%a+)%s+(%d+)%s+%((#[0-9a-zA-Z]+)%)")
    for i = 1, n do
        pos = pos + directions[dir]
        loop[pos] = true
        for i, dir in ipairs(turn[dir]) do
            sides[i][pos + directions[dir]] = true
        end
    end
end

local min_x, max_x = stream.from.keys(loop):map_field("x"):minmax()
local min_y, max_y = stream.from.keys(loop):map_field("y"):minmax()

local function explore(start, seen)
    local outside
    local queue = deq { start }
    while #queue > 0 do
        local cur = queue:dequeue()
        for _, dir in pairs(directions) do
            local neighbour = cur + dir
            if not (loop[neighbour] or seen[neighbour]) then
                if
                    (neighbour.x < min_x or neighbour.x > max_x) or
                    (neighbour.y < min_y or neighbour.y > max_y)
                then
                    outside = true
                else
                    seen[neighbour] = true
                    queue:enqueue(neighbour)
                end
            end
        end
    end
    return outside
end

local inside
for i, side in ipairs(sides) do
    local seen = {}
    for pos in pairs(side) do
        if not (loop[pos] or seen[pos]) then
            seen[pos] = true
            outside   = explore(pos, seen)
            if not outside then
                inside = seen
            end
        end
    end
    sides[i] = seen
end
print(stream.from.keys(inside):count() + stream.from.keys(loop):count())

--[[ DISPLAY
local out = seq {}
for y = min_y, max_y do
    local row = seq {}
    for x = min_x, max_x do
        row:insert(
            loop[point { x, y }]     and "\x1b[91m#" or 
            sides[1][point { x, y }] and "\x1b[92m*" or
            sides[2][point { x, y }] and "\x1b[94m*" or "\x1b[m*"
        )
    end
    out:insert(row)
end

print(out:map(seq.concat):concat("\n") .. "\x1b[0m")
--]]