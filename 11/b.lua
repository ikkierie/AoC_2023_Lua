local func   = require "func"
local point  = require "point"
local seq    = require "seq"
local set    = require "set"
local stream = require "stream"
local struct = require "struct"

local input_space = seq.from.lines([[input.txt]]):apply(seq.from.string)

local empty_rows = input_space
    :map(function(row)
        return row:all(func.meta.eq:bind("."))
            and 999999
            or  0
    end)
    :sum_cumulative()

local empty_cols = stream.from.range(#input_space)
    :map(function(x)
        return input_space
            :slice({}, x)
            :all(func.meta.eq:bind("."))
                and 999999
                or  0
    end)
    :collect(seq)
    :sum_cumulative()

local galaxies = {}
for y, row in ipairs(input_space) do
    for x, pos in ipairs(row) do
        if pos == "#" then
            galaxies[point { 
                x + empty_cols[x],
                y + empty_rows[y],
            }] = true
        end
    end
end

local distances = {}
for g1, i1 in pairs(galaxies) do
    for g2, i2 in pairs(galaxies) do
        if g1 ~= g2 then
            distances[set { g1, g2 }] =
                math.abs(g1.x - g2.x) +
                math.abs(g1.y - g2.y)
        end
    end
end

print(stream.from.values(distances):sum())