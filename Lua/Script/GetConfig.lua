local declaredNames = {}

function declare(name)
  declaredNames[name] = true
end

_dataCache = {}
setmetatable(_dataCache, {
  __newindex = function(t, n, v)
    if not declaredNames[n] then
      error("\229\176\157\232\175\149\229\134\153\229\133\165\230\156\170\229\163\176\230\152\142\231\154\132\229\143\152\233\135\143: " .. n, 2)
    else
      rawset(t, n, v)
    end
  end,
  __index = function(t, n)
    if not declaredNames[n] then
      error("\229\176\157\232\175\149\232\175\187\229\143\150\230\156\170\229\163\176\230\152\142\231\154\132\229\143\152\233\135\143: " .. n, 2)
    else
      return rawget(t, n)
    end
  end
})

function GetCA(id, factoryName)
  local id = tonumber(id)
  if id == nil or id < 10000000 or 99999999 < id then
    return
  end
  declare(id)
  if _dataCache[id] then
    return _dataCache[id]
  end
  factoryName = factoryName or DataManager:GetFactoryNameById(id)
  declare(factoryName)
  if _dataCache[factoryName] then
    return _dataCache[factoryName][id]
  end
  DataManager:CacheCAToLua(id)
  return _dataCache[id]
end

function RefreshCA(id, factoryName)
  local id = tonumber(id)
  if id == nil or id < 10000000 or 99999999 < id then
    print_r(factoryName .. "\230\129\173\229\150\156\228\189\160\239\188\140\231\187\153\228\186\134\228\184\128\228\184\170\233\148\153\232\175\175\231\154\132\229\128\188\232\191\155\230\157\165...id--" .. tostring(id))
    return
  end
  declare(id)
  if _dataCache[id] then
    _dataCache[id] = nil
  end
  factoryName = factoryName or DataManager:GetFactoryNameById(id)
  declare(factoryName)
  if _dataCache[factoryName] and _dataCache[factoryName][id] then
    _dataCache[factoryName][id] = nil
  end
  DataManager:CacheCAToLua(id, true)
end

function CacheFactory(factoryName)
  declare(factoryName)
  DataManager:CacheFactory(factoryName)
end

function CacheAndGetFactory(factoryName)
  declare(factoryName)
  if _dataCache[factoryName] then
    return _dataCache[factoryName]
  end
  CacheFactory(factoryName)
  return _dataCache[factoryName]
end
