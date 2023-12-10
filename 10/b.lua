local colour = require "colour"
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
    ["."] = {},
}

local grid  = {}
local y     = 1
local max_x = 0
local max_y = 0
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
        max_x = math.max(x, max_x)
    end
    y = y + 1
end
max_y = y - 1

for _, dir in pairs(directions) do
    local pos       = grid.start + dir
    local neighbour = grid[pos]
    if neighbour then
        grid[grid.start][pos] = neighbour[grid.start]
    end
end

local visited = {}
local queue   = { grid.start }
while queue[1] do
    local cur = table.remove(queue, 1)
    for neighbour in pairs(grid[cur]) do
        if not visited[neighbour] then
            table.insert(queue, neighbour)
            visited[neighbour] = true
        end
    end
end

for _, pos in ipairs(seq.from.keys(visited)) do
    local neighbours = grid[pos]
    for neighbour in pairs(neighbours) do
        visited[pos + (neighbour - pos) / 2] = true
    end
end

local function dijkstra(start)
    local is_outside
    local seen  = { [start] = true }
    local queue = { start }
    while queue[1] do
        local cur = table.remove(queue, 1)
        for _, dir in pairs(directions) do
            local neighbour = cur + dir / 2
            if 
                neighbour.x <= 0 or neighbour.x >= (max_x + 1) or 
                neighbour.y <= 0 or neighbour.y >= (max_y + 1) 
            then
                is_outside = true
            elseif not visited[neighbour] then
                if not seen[neighbour] then
                    table.insert(queue, neighbour)
                    seen[neighbour] = true
                end
            else
            end
        end
    end
    return seen, is_outside
end

local inside  = {}
local outside = {}
local loop    = visited
local area = 0
for pos in pairs(grid) do
    if not (loop[pos] or outside[pos] or inside[pos]) and point.type(pos) then
        local seen, is_outside = dijkstra(pos)
        if not is_outside then
            area = area + stream.from.keys(seen)
                :where(function(p) 
                    return  p.x % 1 == 0 
                        and p.y % 1 == 0 
                end)
                :count()
            for pos in pairs(seen) do
                inside[pos] = true
            end
        else
            for pos in pairs(seen) do
                outside[pos] = true
            end
        end
    end
end

print(area)

--[=[ Visualisation Code
local vis_map = {
    ["|"] = "┃",
    ["-"] = "━",
    ["L"] = "┗",
    ["J"] = "┛",
    ["7"] = "┓",
    ["F"] = "┏",
    ["."] = ".",
}

local y = 1
for line in io.lines([[input.txt]]) do
    for x, chr in line:gmatch("()(.)") do
        local p = point { x, y }
        local r = loop[p]    and 0xff
        local g = inside[p]  and 0xff
        local b = outside[p] and 0xff
        io.write(
            -- colour.ansi(r or g, 0x80, r or b),
            colour.ansi(r, g, b),
            vis_map[loop[p] and chr or "."] or chr,
            colour.ansi()
        )
    end
    print()
    y = y + 1
end
--]=]