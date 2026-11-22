local str = {}

function str.str_format(msg, ...)
  local pattern = "{%d+}"
  local isMatch = string.find(msg, pattern)
  if isMatch == nil then
    return string.format(msg, ...)
  end
  local matchList = string.gmatch(msg, pattern)
  local args = {
    ...
  }
  local tableParams = {}
  local num = 1
  for v in matchList, nil, nil do
    local i_str = string.gsub(v, "[{}]", "")
    local index = tonumber(i_str)
    local count = #args
    if index > count then
      index = count - 1
    end
    local result = args[index]
    tableParams[num] = result
    num = num + 1
  end
  local msgNew = string.gsub(msg, "{%d+}", "")
  local count = #tableParams
  local arg1, arg2, arg3, arg4, arg5
  if 5 <= count then
    arg5 = tableParams[5]
  end
  if 4 <= count then
    arg4 = tableParams[4]
  end
  if 3 <= count then
    arg3 = tableParams[3]
  end
  if 2 <= count then
    arg2 = tableParams[2]
  end
  if 1 <= count then
    arg1 = tableParams[1]
  end
  return string.format(msgNew, arg1, arg2, arg3, arg4, arg5)
end

return str
