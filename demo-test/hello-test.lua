test('hello test error', function()

  local a = #nil
end)

test('hello test ok', function()
 
  print(222222 .. '\n\n')
end)

test('hello test error', function()
  error('line10')
end)

