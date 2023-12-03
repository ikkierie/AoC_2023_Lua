local seq = require "seq"

local sum = 0
for line in io.lines([[input.txt]]) do
    local digits = seq.from.iterator(line:gmatch("%d"))
    sum = sum + (digits[1] .. digits[#digits])
end

print(sum)