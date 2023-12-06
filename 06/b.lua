local race = {}
for line in io.lines([[input.txt]]) do
    local field = line:match("^(%a+)"):lower()
    race[field] = tonumber((line:gsub("[^%d]+", "")))
end

local count = 0
local time  = race.time
for speed = 0, race.time do
    local distance = speed * (time - speed)
    if distance > race.distance then
        count = count + 1 
    end
end
print(count)