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
  if status == false then -- true is ok
    local trace = debug.traceback(err, 2)
    if trace == nil then
      trace = 'a\n\tfail to get trace\n'
    end
    reporter({
      errTrace = trace,
      errMsg = errMsg,
      description = description
    })
  else
    reporter({description = description})
  end
end

-- TODO: need cool assert function like assertEqual deepEqual

-- get all file

package.path = package.path .. ';../demo-src/?.lua;./demo-src/?.lua;./demo-test/?.lua'

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

print(os.execute('lua -v'))

if (EXIT == 1) then
  error() -- simple error ret for ci like travis
end
