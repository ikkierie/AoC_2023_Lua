local deq    = require "deq"
local func   = require "func"
local seq    = require "seq"
local stream = require "stream"

local LOW <const>, HIGH <const> = false, true

local make_module = {
    broadcaster = (function()
        return (function(self, pulse)
            return self.dsts:map_with_v(pulse, self.name)
        end)
    end),

    ["%"] = (function()
        local state = false
        return (function(self, pulse)
            if pulse then
                return seq {}
            else
                state = not state
                return self.dsts:map_with_v(state, self.name)
            end
        end)
    end),

    ["&"] = (function()
        local state = {}
        return (function(self, pulse, src)
            state[src] = pulse
            local fwd  = stream.from.seq(self.srcs)
                :map(function(x) return not state[x] end)
                :reduce(func.logic.OR)
            return self.dsts:map_with_v(fwd, self.name)
        end)
    end),
}

local modules = {}
for line in io.lines([[input.txt]]) do
    local type, name, dsts = line:match("^([%%&]?)(%S-)%s+%->%s+(.+)$")
    type = (#type > 0) and type or "broadcaster"
    dsts = seq.from.string(dsts, "%s*,%s*")

    modules[name] = {
        type   = type,
        name   = name,
        dsts   = dsts,
        srcs   = seq {},
        action = make_module[type](),
    }
end

for name, module in pairs(modules) do
    for _, dst in ipairs(module.dsts) do
        if not modules[dst] then
            modules[dst] = {
                name   = dst,
                dsts   = {},
                srcs   = seq {},
                action = seq.of:fuse(),
            }
        end
        modules[dst].srcs:insert(name)
    end
end

local n_pulses = { [LOW] = 0, [HIGH] = 0 }
for i = 1, 1000 do
    local action_queue = deq { { "broadcaster", LOW } }
    while #action_queue > 0 do
        local name, pulse, src = table.unpack(action_queue:dequeue())
        modules[name]
            :action(pulse, src)
            :foreach(deq.enqueue:bind(action_queue))
        n_pulses[pulse] = n_pulses[pulse] + 1
    end
end
print(n_pulses[LOW] * n_pulses[HIGH])