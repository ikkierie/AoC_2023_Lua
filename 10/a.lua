local point  = require "point"
local seq    = require "seq"
local stream = require "stream"

local directions = {
    north = point {  0, -1 },
    south = point {  0,  1 },
    east  = point {  1,  0 },
    west  = point { -1,  0 },
}

local pipes = {
    ["|"] = { "north", "south" },
    ["-"] = { "east",  "west"  },
    ["L"] = { "north", "east"  },
    ["J"] = { "north", "west"  },
    ["7"] = { "south", "west"  },
    ["F"] = { "south", "east"  },
}

local grid = {}
local y    = 1
for line in io.lines([[input.txt]]) do
    for x, pipe in line:gmatch("()(.)") do
        local pos = point { x, y }
        if pipe == "S" then
            grid.start = pos
            grid[pos]  = {}
        elseif pipes[pipe] then
            local neighbours = {}
            for _, dir in ipairs(pipes[pipe]) do
                neighbours[pos + directions[dir]] = true
            end
            grid[pos] = neighbours
        end
    end
    y = y + 1
end

for _, dir in pairs(directions) do
    local pos       = grid.start + dir
    local neighbour = grid[pos]
    if neighbour then
        grid[grid.start][pos] = neighbour[grid.start]
    end
end

local visited = {}
local seen    = { [grid.start] = 0 }
local queue   = { grid.start }
while queue[1] do
    local cur = table.remove(queue, 1)
    visited[cur] = seen[cur]
    for neighbour in pairs(grid[cur]) do
        if not visited[neighbour] then
            if not seen[neighbour] then
                table.insert(queue, neighbour)
            end
            seen[neighbour] = math.min(
                visited[cur] + 1,
                seen[neighbour] or math.huge
            )
        end
    end
end

print(seq.from.values(visited):reduce(math.max))