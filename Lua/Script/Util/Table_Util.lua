function table.count(t)
  local count = 0
  
  for i, v in pairs(t) do
    count = count + 1
  end
  return count
end

function table.GetTableState(list)
  if list ~= nil and table.count(list) > 0 then
    return true
  end
  return false
end

function GetTimeData(time)
  local tl = {}
  tl.day = math.floor(time / 60 / 60 / 24)
  tl.hour = math.floor(time / 3600) % 24
  tl.minute = math.floor(time / 60) % 60
  tl.second = math.floor(time % 60)
  if tl.hour > 0 then
    if tl.second < 10 then
      local second = "0" .. tl.second
      return tl.hour .. ":" .. tl.minute .. ":" .. second
    else
      return tl.hour .. ":" .. tl.minute .. ":" .. tl.second
    end
  end
  if tl.minute > 0 and tl.minute < 10 then
    if tl.second < 10 then
      local second = "0" .. tl.second
      return "0" .. tl.minute .. ":" .. second
    else
      return "0" .. tl.minute .. ":" .. tl.second
    end
  end
  if tl.second >= 0 then
    return "00" .. ":" .. tl.second
  end
  return ""
end

local function find(a, tbl)
  for _, a_ in ipairs(tbl) do
    if a_ == a then
      return true
    end
  end
end

function table:Difference(a, b)
  local row = {}
  local aRow = {}
  local count = 0
  for _, a_ in ipairs(a) do
    if a_ ~= b[_] then
      count = count + 1
      table.insert(row, b[_])
      table.insert(aRow, a_)
    end
  end
  return count, row, aRow
end

function table:NewDifference(a, b)
  local row = {}
  local count = 0
  local a_count = table.count(a)
  local b_count = table.count(b)
  if a_count == 0 then
    if b_count == 0 then
      return count, row
    else
      return b_count, b
    end
  elseif b_count == 0 then
    return a_count, a
  else
    if a_count < b_count then
      for _, b_ in pairs(b) do
        if a[_] == nil then
          count = count + 1
          table.insert(row, b_)
        end
      end
      return count, row
    end
    if a_count > b_count then
      for _, a_ in pairs(a) do
        if b[_] == nil then
          count = count + 1
          table.insert(row, a_)
        end
      end
      return count, row
    end
  end
  return count, row
end

function table.containsKey(t, k)
  if not t then
    return false
  end
  for i, _ in pairs(t) do
    if i == k then
      return true
    end
  end
  return false
end

function table.contains(t, v)
  if not t then
    return false
  end
  for _, value in pairs(t) do
    if value == v then
      return true
    end
  end
  return false
end

function table.list_remove(t, v)
  if not t then
    return false
  end
  for index, value in ipairs(t) do
    if value == v then
      table.remove(t, index)
      return true
    end
  end
  return false
end

function table.list_indexof(t, v)
  assert(t ~= nil and type(t) == "table" and 0 < #t, "\229\143\130\230\149\176\233\148\153\232\175\175! [table\230\149\176\230\141\174\233\148\153\232\175\175]")
  for index, value in ipairs(t) do
    if value == v then
      return index
    end
  end
  return nil
end
