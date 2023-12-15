local input do
    local f <close> = assert(io.open([[input.txt]]))
    input = f:read("*all")
end

local function hash(str)
    local hash = 0
    for c in str:gmatch(".") do
        hash = (hash + c:byte()) * 17 % 256
    end
    return hash
end

local sum = 0
for str in input:gsub("\n", ""):gmatch("[^,]+") do
    sum = sum + hash(str)
end
print(sum)