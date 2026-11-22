local DataModel = {
  curSelectedIndex = -1,
  curSelectedRoles = {},
  maxNum = 3,
  sortType = {
    Level = true,
    Rarity = true,
    Time = true
  },
  curSortType = "Level"
}

function DataModel:RefreshRoleList()
  self.SortRoles = {}
  for k, v in pairs(PlayerData.ServerData.roles) do
    local data = Clone(v)
    local roleIndex = 0
    for i = 1, DataModel.maxNum do
      if DataModel.curSelectedRoles[i] == data.id then
        roleIndex = i
        break
      end
    end
    if roleIndex and 0 < roleIndex then
      data.squads_index = roleIndex
    else
      data.squads_index = 0
    end
    table.insert(DataModel.SortRoles, data)
  end
end

function DataModel:SortAllRoles(sortType)
  self.curSortType = sortType or "Level"
  if self.curSortType == "Level" then
    self:SortRoleByType(DataModel.CompareByLv)
  elseif self.curSortType == "Rarity" then
    self:SortRoleByType(DataModel.CompareByRarity)
  elseif self.curSortType == "Time" then
    self:SortRoleByType(DataModel.CompareByTime)
  end
end

function DataModel:SortRoleByType(cb)
  table.sort(DataModel.SortRoles, function(r1, r2)
    return DataModel.CompareByIndex(r1, r2, cb)
  end)
end

function DataModel.CompareByIndex(r1, r2, cb)
  if r1.squads_index <= 0 and r2.squads_index <= 0 then
    return cb(r1, r2)
  elseif r1.squads_index > 0 and r2.squads_index > 0 then
    return r1.squads_index < r2.squads_index
  else
    return r1.squads_index > r2.squads_index
  end
end

function DataModel.CompareByLv(r1, r2)
  local ret
  if r1.lv ~= r2.lv then
    if DataModel.sortType.Level then
      ret = r1.lv > r2.lv
    else
      ret = r1.lv < r2.lv
    end
  else
    ret = tonumber(r1.id) > tonumber(r2.id)
  end
  return ret
end

function DataModel.CompareByRarity(r1, r2)
  local ret
  local ca1 = PlayerData:GetFactoryData(r1.id)
  local ca2 = PlayerData:GetFactoryData(r2.id)
  if ca1.qualityInt ~= ca2.qualityInt then
    if DataModel.sortType.Rarity then
      ret = ca1.qualityInt > ca2.qualityInt
    else
      ret = ca1.qualityInt < ca2.qualityInt
    end
  else
    ret = tonumber(r1.id) > tonumber(r2.id)
  end
  return ret
end

function DataModel.CompareByTime(r1, r2)
  local ret
  if r1.obtain_time ~= r2.obtain_time then
    if DataModel.sortType.Time then
      ret = r1.obtain_time < r2.obtain_time
    else
      ret = r1.obtain_time > r2.obtain_time
    end
  else
    ret = tonumber(r1.id) > tonumber(r2.id)
  end
  return ret
end

return DataModel
