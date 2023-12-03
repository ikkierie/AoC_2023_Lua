local point = require "point"
local seq   = require "seq"

local grid = {
    numbers = {},
    symbols = {},
}
local y = 1
for line in io.lines([[input.txt]]) do
    for pos, digit in line:gmatch("()(%d+)") do
        for x = pos, pos + #digit - 1 do
            grid.numbers[point { x, y }] = digit
        end
    end
    for pos, symbol in line:gmatch("()(%*)") do
        grid.symbols[point { pos, y }] = symbol
    end
    y = y + 1
end

local sum = 0
for pos, gear in pairs(grid.symbols) do
    local ns = seq {}
    for y = -1, 1 do
        for x = -1, 1 do
            local p = point { pos.x + x, pos.y + y }
            local n = grid.numbers[p]
            if n then
                ns:insert(n)
            end
        end
    end
    ns:remove_duplicates()
    if #ns >= 2 then
        sum = sum + ns[1] * ns[2]
    end
end
print(sum)