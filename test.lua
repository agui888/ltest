-- simple & pretty lua test
-- assume lua tests are all sync waterfall (because this will easy..

local c = require 'ansicolors'

local OK_COLOR = {'green', 'grey'}

local ERR_COLOR = {'red', 'white', 'red', 'grey'}

local EXIT = 0

local function prettyPrint(texts, colors)
  local arr = {}
  for i = 1, #texts do
    table.insert(arr, c('%{' .. colors[i] .. '}' .. texts[i]))
  end
  print(table.concat(arr) .. '\n')
end

local function reporter(o)
  -- errTrace, errMsg, description, duration(no Milliseconds..)
  if o.errTrace then
    local index = string.find(o.errTrace, '\n')
    o.errTrace = string.sub(o.errTrace, index + 1, #o.errTrace)
    prettyPrint({'  ✖ ', o.description .. ' ', '\n    ' .. o.errMsg, '\n' .. o.errTrace}, ERR_COLOR)
    EXIT = 1
    return
  end
  prettyPrint({'  ✓ ', o.description .. ' '}, OK_COLOR)
end


function test(description, fn)
  local status, errMsg = pcall(fn)
  if status then -- true is ok
    return reporter({description = description})
  end
  reporter({
    errTrace = debug.traceback(err, 2),
    errMsg = errMsg,
    description = description
  })
end

-- TODO: need cool assert function like assertEqual deepEqual

-- get all file

if #arg > 0 then
  for i = 1, #arg do
    local f = arg[i]
    local index = string.find(f, '.lua')
    if index and index > 0 then
      f = string.sub(f, 1, index - 1)
    end
    require(f)
  end
else
  print('no input file')
end

error(3333333)

if (EXIT == 1) then
  error() -- simple error ret for ci like travis
end
