local func   = require "func"
local seq    = require "seq"
local stream = require "stream"

local iter = stream.from.lines([[input.txt]])
    :split_by_v("")
    :map(seq)
    :map(seq.apply:bind2(seq.from.string))

local rows = 0
local cols = 0
for pattern in iter do
    local x = #pattern[1]
    local y = #pattern
    for row = 1, (y - 1) do
        local d    = math.min(row, y - row)
        local up   = pattern:slice({ row - d + 1, row      }, {})
        local down = pattern:slice({ row + 1,     row + d  }, {}):reverse()
        for y = 1, #up do
            for x = 1, #up[y] do
                local before = up[y][x]
                up[y][x] = (before == ".") and "#" or "."
                if up == down then
                    rows = rows + row
                    goto next_pattern
                end
                up[y][x] = before
            end
        end
    end

    for col = 1, (x - 1) do
        local d     = math.min(col, x - col)
        local left  = pattern:slice({}, { col - d + 1, col      })
        local right = pattern:slice({}, { col + 1,     col + d  }):apply(seq.reversed)
        for y = 1, #left do
            for x = 1, #left[y] do
                local before = left[y][x]
                left[y][x] = (before == ".") and "#" or "."
                if left == right then
                    cols = cols + col
                    goto next_pattern
                end
                left[y][x] = before
            end
        end
    end

    ::next_pattern::
end

print(cols + 100 * rows)