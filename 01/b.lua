local pcre   = require "pcre"
local stream = require "stream"

local pattern = pcre"[0-9]|one|two|three|four|five|six|seven|eight|nine"

local digits = { 
    one   = 1, two   = 2, three = 3, 
    four  = 4, five  = 5, six   = 6, 
    seven = 7, eight = 8, nine  = 9,
}
local function get_digit(digit)
    return digits[digit] or digit
end

local sum = 0
for line in io.lines([[input.txt]]) do
    local digits = stream.from.range(#line)
        :map(function(x) return pattern:match(line, x) end)
        :map(get_digit)
        :collect()
    sum = sum + (digits[1] .. digits[#digits])
end

print(sum)