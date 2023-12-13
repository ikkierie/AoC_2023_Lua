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
    local y = #pattern
    for row = 1, (y - 1) do
        local d    = math.min(row, y - row)
        local up   = pattern:slice({ row - d + 1, row      }, {})
        local down = pattern:slice({ row + 1,     row + d  }, {}):reverse()
        if up == down then
            rows = rows + row
            goto next_pattern
        end
    end

    local x = #pattern[1]
    for col = 1, (x - 1) do
        local d     = math.min(col, x - col)
        local left  = pattern:slice({}, { col - d + 1, col      })
        local right = pattern:slice({}, { col + 1,     col + d  }):apply(seq.reversed)
        if left == right then
            cols = cols + col
            goto next_pattern
        end
    end

    ::next_pattern::
end

print(cols + 100 * rows)