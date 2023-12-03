local point = require "point"

local grid = {
    numbers = {},
    symbols = {},
}
local y = 1
for line in io.lines([[input.txt]]) do
    for pos, digit in line:gmatch("()(%d+)") do
        grid.numbers[point { pos, y }] = digit
    end
    for pos, symbol in line:gmatch("()([^%d%.]+)") do
        grid.symbols[point { pos, y }] = symbol
    end
    y = y + 1
end

local sum = 0
for pos, digit in pairs(grid.numbers) do
    for i = pos.x, pos.x + #digit - 1 do
        for y = -1, 1 do
            for x = -1, 1 do
                local p = point { i + x, pos.y + y }
                local s = grid.symbols[p]
                if s then
                    sum = sum + digit
                    goto found
                end
            end
        end
    end
    ::found::
end
print(sum)