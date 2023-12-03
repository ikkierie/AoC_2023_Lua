local input do
    local f <close> = assert(io.open([[input.txt]]))
    input = f:read("*all")
end

local sum = 0
for id, rest in input:gmatch("Game (%d+): ([^\n]+)") do
    local max = {}
    for n, colour in rest:gmatch("(%d+)%s+(%a+)") do
        max[colour] = math.max(max[colour] or 0, tonumber(n))
    end
    sum = sum + (
        (max.red   or 0) *
        (max.green or 0) *
        (max.blue  or 0)
    )
end

print(sum)