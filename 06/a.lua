local races = {}
for line in io.lines([[input.txt]]) do
    local field = line:match("^(%a+)"):lower()
    local i = 0
    for n in line:gmatch("%d+") do
        i = i + 1
        races[i]        = races[i] or {}
        races[i][field] = tonumber(n)
    end
end

local prod = 1
for _, race in ipairs(races) do
    local count = 0
    local time  = race.time
    for speed = 0, race.time do
        local distance = speed * (time - speed)
        if distance > race.distance then
            count = count + 1 
        end
    end
    prod = prod * count
end
print(prod)