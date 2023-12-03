local input do
    local f <close> = assert(io.open([[input.txt]]))
    input = f:read("*all")
end

local max = { red = 12, green = 13, blue = 14 }

local sum = 0
for id, rest in input:gmatch("Game (%d+): ([^\n]+)") do
    for n, colour in rest:gmatch("(%d+)%s+(%a+)") do
        if tonumber(n) > max[colour] then
            goto continue
        end
    end
    sum = sum + id
    ::continue::
end

print(sum)