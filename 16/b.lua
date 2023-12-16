local grid = {}
for line in io.lines([[input.txt]]) do
    local row = {}
    for chr in line:gmatch(".") do
        table.insert(row, chr)
    end
    table.insert(grid, row)
end

local turn = {
    ["/"] = {  
        up    = { "right" },
        down  = { "left"  },
        left  = { "down"  },
        right = { "up"    },
    },

    ["\\"] = {
        up    = { "left"  },
        down  = { "right" },
        left  = { "up"    },
        right = { "down"  },
    },

    ["|"] = {
        up    = { "up"         },
        down  = { "down"       },
        left  = { "up", "down" },
        right = { "up", "down" },
    },

    ["-"] = {
        up    = { "left", "right" },
        down  = { "left", "right" },
        left  = { "left"          },
        right = { "right",        },
    },

    ["."] = {
        up    = { "up"    },
        down  = { "down"  },
        left  = { "left"  },
        right = { "right" },
    },
}
local move = {
    up    = (function(x, y) return x,     y - 1 end),
    down  = (function(x, y) return x,     y + 1 end),
    left  = (function(x, y) return x - 1, y     end),
    right = (function(x, y) return x + 1, y     end),
}

local function energise(dir, x, y)
    local energised = {}
    local seen      = {}
    local queue     = { { dir, x, y } }
    while #queue > 0 do
        local cur       = table.remove(queue, 1)
        local dir, x, y = table.unpack(cur)

        energised[x .. "," .. y] = true

        local x, y = move[dir](x, y)
        if grid[y] and grid[y][x] then
            for _, next in ipairs(turn[grid[y][x]][dir]) do
                local next = { next, x, y }
                local repr = table.concat(next, ",")
                if not seen[repr] then
                    table.insert(queue, next)
                end
                seen[repr] = true
            end
        end
    end

    local size = 0
    for _ in pairs(energised) do
        size = size + 1
    end
    return size
end

local max = 0
for y = 1, #grid do
    max = math.max(
        energise("right", 1,        y),
        energise("left",  #grid[y], y),
        max
    )
end
for x = 1, #grid[1] do
    max = math.max(
        energise("down", x, 1),
        energise("up",   x, #grid),
        max
    )
end
print(max)