local dumpTable

function dump(v, indent)
    -- TODO userdata
    local t = type(v)
    if t == 'number' or t == 'boolean' then
        return tostring(v)
    elseif t == 'string' then
        return "'" .. v .. "'"
    elseif t == 'table' then
        return dumpTable(v, indent)
    elseif t == 'nil' then
        return 'null'
    else
    end
    return '[' .. t .. ']'
    --[[
    elseif t == 'function' then
        return '[Function]'
    end
    return '[Unknown]'
    ]]
end

function dumpTable(o, _indent)
    if type(_indent) ~= 'string' then
        _indent = ''
    end
    local indent = '    ' .. _indent
    if #indent > 4 * 7 then
        return '[Nested]' -- may be nested
    end
    local ret = '{\n'
    local arr = {}
    for k, v in pairs(o) do
        -- ret = ret .. indent .. k .. ': ' .. dump(v, indent) .. ',\n'
        table.insert(arr, indent .. dump(k) .. ': ' .. dump(v, indent))
    end
    ret = ret .. table.concat(arr, ',\n') .. '\n' .. _indent .. '}'
    return ret
end

local function str(val)
   local str = "\n\n=======================\n"
   str = str .. val
   str = str .. "\n=========================\n"
   return str
end

function p(...)
    local tb = {}
    for k, v in pairs({...}) do
        table.insert(tb, dump(v))
    end
    local _str = str(table.concat(tb, ' '))
    --ngx.say(_str)
    print(_str)
end

string.trim = function(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

string.split = function(s, pattern)
    local ret = {}
    local reg = '[^' .. pattern .. ']+'
    for v in string.gmatch(s, reg) do
        table.insert(ret, v)
    end
    return ret
end
--[[
local base = {
    a = 1
}
base.new = function()
    p(self)
end

base:new(12)]]
--[[
local t = {}
t.say = function()
  print(333)
end
setmetatable(t, {
  __call = function()
    print(3333333)
  end,
  __index = function(table, k)
    return 'this is a key: ' .. k
  end
})
print(t.b)
]]

local mod = {}

function mod:new(name)
  local o = {}
  o.name = name
  setmetatable(o, {
    __index = self
  })
  return o
end

function mod:say()
  p(self)
  p(self.name)
end

local mod1 = mod:new('XiaoHong')
mod1:say()

