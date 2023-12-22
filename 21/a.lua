local deq       = require "deq"
local enumerate = require "enumerate"
local point     = require "point"
local stream    = require "stream"

local directions = {
    north = point {  0, -1 },
    east  = point {  1,  0 },
    south = point {  0,  1 },
    west  = point { -1,  0 },
}

local grid = {}
for y, line in enumerate(io.lines([[input.txt]])) do
    for x, chr in line:gmatch("()(.)") do
        if chr ~= "#" then
            local pos = point { x, y }
            if chr == "S" then
                grid.start = pos
            end
            grid[pos] = true
        end
    end
end

local function explore(start)
    local visited = {}
    local seen    = { [start] = 0 }
    local queue   = deq { start }
    while #queue > 0 do
        local cur    = queue:dequeue()
        visited[cur] = seen[cur]
        for _, dir in pairs(directions) do
            local neighbour = cur + dir
            if grid[neighbour] and not visited[neighbour] then
                if not seen[neighbour] then
                    queue:enqueue(neighbour)
                end
                seen[neighbour] = math.min(
                    seen[cur] + 1,
                    seen[neighbour] or math.huge
                )
            end
        end
    end
    return visited
end

local visited = explore(grid.start)
local count   = stream.from.pairs(visited)
    :where__u(function(_, n) 
        return (n % 2 == 0) and (n <= 64)
    end)
    :count()
print(count)