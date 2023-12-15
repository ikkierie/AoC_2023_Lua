require "func"
require "utils"

local grid = seq.from.lines([[input.txt]]):apply(seq.from.string)

local score = 0
for x = 1, #grid[1] do
    for y = 1, #grid do
        local row   = grid[y]
        local piece = row[x]
        if piece == "O" then
            -- io.write("\x1b[2J\x1b[H")
            -- print(x, y)
            -- local before = grid[y][x]
            -- grid[y][x] = "\x1b[93m0\x1b[m"
            -- print(grid:map(seq.concat):concat("\n"))
            -- grid[y][x] = before
            -- io.read()
            row[x] = "."
            while y > 1 do
                -- io.write("\x1b[2J\x1b[H")
                -- print(x, y)
                -- local before = grid[y][x]
                -- grid[y][x] = "\x1b[91m0\x1b[m"
                -- print(grid:map(seq.concat):concat("\n"))
                -- grid[y][x] = before
                -- io.read()
                if grid[y - 1] and grid[y - 1][x] ~= "." then
                    break
                end
                y = y - 1
            end
            -- io.write("\x1b[2J\x1b[H")
            -- print(x, y)
            -- local before = grid[y][x]
            -- grid[y][x] = "\x1b[92m0\x1b[m"
            -- print(grid:map(seq.concat):concat("\n"))
            -- grid[y][x] = before
            -- io.read()
            grid[y][x] = piece
            score      = score - y + #grid + 1
        end
    end
end
print(score)

-- DON'T FORGET TO MOVE TO b.lua FOR PART B