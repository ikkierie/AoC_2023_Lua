require "func"
require "utils"

local grid = seq.from.lines([[input.txt]]):apply(seq.from.string)

local function display(x, y, colour)
    io.write("\x1b[2J\x1b[H")
    print(x, y)
    local before = grid[y][x]
    grid[y][x] = "\x1b[" .. (colour or 0) .. "m0\x1b[m"
    print(grid:map(seq.concat):concat("\n"))
    grid[y][x] = before
    io.read()
end

local score = 0
for x = 1, #grid[1] do
    for y = 1, #grid do
        local piece = grid[y][x]
        if piece == "O" then
            -- display(x, y, 93)
            grid[y][x] = "."
            while y > 1 do
                -- display(x, y, 91)
                if grid[y - 1] and (grid[y - 1][x] ~= ".") then
                    break
                end
                y = y - 1
            end
            -- display(x, y, 92)
            grid[y][x] = piece
            score      = score - y + #grid + 1
        end
    end
end
print(score)

-- DON'T FORGET TO MOVE TO b.lua FOR PART B