test('hello test error', function()
  local a = #nil
end)

test('hello test ok', function()
 
end)

test('hello test error', function()
  error('line10')
end)

