local DataModel = {
  HomeSkillInfo = {},
  ShowPlaceType = 1,
  ShowType2Tag = {
    [1] = 1,
    [2] = 5
  }
}

function DataModel.Init()
  DataModel.HomeSkillInfo = {}
  local curStationId = 0
  local station_info = PlayerData:GetHomeInfo().station_info
  if station_info ~= nil then
    local stop_info = station_info.stop_info
    if stop_info ~= nil and stop_info[2] == -1 then
      curStationId = tonumber(stop_info[1])
    end
  end
  local homeSkillTypeIndex = {}
  local indexRecord = 0
  local stationCA = PlayerData:GetFactoryData(curStationId)
  local sellDic = {}
  if stationCA then
    for i, v in ipairs(stationCA.sellList) do
      local goodsCA = PlayerData:GetFactoryData(v.id)
      sellDic[goodsCA.goodsId] = 0
    end
  end
  
  local function checkGoodsIsInCity(goodsList, sellList)
    if goodsList == nil then
      return true
    end
    for i, v in ipairs(goodsList) do
      if sellList[v.id] then
        return true
      end
    end
    return false
  end
  
  local function generalAddHomeSkillFunc(homeSkillList, unitId, skinId)
    local len = #homeSkillList
    local homeSkillPreSkillIdRecord = {}
    for k1, v1 in ipairs(homeSkillList) do
      local homeSkillCA = PlayerData:GetFactoryData(v1.id, "HomeSkillFactory")
      if homeSkillCA.tag == DataModel.ShowType2Tag[DataModel.ShowPlaceType] and homeSkillPreSkillIdRecord[v1.id] == nil and ((homeSkillCA.city == nil or homeSkillCA.city <= 0) and checkGoodsIsInCity(homeSkillCA.goodsList, sellDic) or homeSkillCA.city and homeSkillCA.city == curStationId) then
        local t = {}
        t.unitId = unitId
        t.resonanceLv = v1.resonanceLv or 0
        t.nextId = 0
        t.param = homeSkillCA.param
        t.skillLv = 1
        t.hadUnit = false
        t.unlock = false
        local serverInfo = PlayerData:GetRoleById(unitId)
        if skinId == nil then
          if serverInfo and 0 < table.count(serverInfo) then
            t.hadUnit = true
            if serverInfo.resonance_lv >= t.resonanceLv then
              t.unlock = true
            end
          end
        elseif serverInfo and 0 < table.count(serverInfo) then
          t.hadUnit = true
          local serverSkinList = serverInfo.skin_list
          if serverSkinList then
            for tempSkinId, v in pairs(serverSkinList) do
              if tonumber(tempSkinId) == skinId then
                t.unlock = true
              end
            end
          end
        else
          local serverNoHeroSkin = PlayerData.ServerData.skin_no_hero
          if serverNoHeroSkin and serverNoHeroSkin[tostring(unitId)] then
            for i, tempSkinId in ipairs(serverNoHeroSkin[tostring(unitId)]) do
              if tonumber(tempSkinId) == skinId then
                t.unlock = true
              end
            end
          end
        end
        local info = v1
        while info.nextIndex and 0 < info.nextIndex and len >= info.nextIndex do
          local recordSelfId = info.id
          info = homeSkillList[info.nextIndex]
          local nextId = info.id
          local nextResonanceLv = info.resonanceLv
          homeSkillPreSkillIdRecord[nextId] = recordSelfId
          if t.unlock and 0 < nextId and nextResonanceLv <= serverInfo.resonance_lv then
            local nextHomeSkillCA = PlayerData:GetFactoryData(nextId, "HomeSkillFactory")
            t.param = t.param + nextHomeSkillCA.param
            t.skillLv = t.skillLv + 1
          end
        end
        local isSameUnit = false
        local recordTable
        local typeKey = homeSkillCA.homeSkillType
        if homeSkillCA.homeSkillType == EnumDefine.HomeSkillEnum.AddQty then
          if homeSkillCA.goodsList then
            local str = ""
            for i, v in ipairs(homeSkillCA.goodsList) do
              str = str .. "," .. v.id
            end
            typeKey = typeKey .. str
          end
        elseif homeSkillCA.homeSkillType == EnumDefine.HomeSkillEnum.AddSpecQty and homeSkillCA.city and homeSkillCA.city > 0 then
          typeKey = typeKey .. "," .. homeSkillCA.city
        end
        if homeSkillTypeIndex[typeKey] then
          recordTable = DataModel.HomeSkillInfo[homeSkillTypeIndex[typeKey]]
          for i, unitInfo in ipairs(recordTable.unitInfo) do
            if unitInfo.unitId == unitId then
              isSameUnit = true
              if t.skillLv > unitInfo.skillLv then
                unitInfo.skillLv = t.skillLv
              end
              break
            end
          end
        else
          recordTable = {}
          indexRecord = indexRecord + 1
          homeSkillTypeIndex[typeKey] = indexRecord
          recordTable.id = v1.id
          recordTable.homeSkillCA = homeSkillCA
          recordTable.unlockCount = 0
          recordTable.param = 0
          recordTable.unitInfo = {}
          DataModel.HomeSkillInfo[indexRecord] = recordTable
          isSameUnit = false
        end
        if not isSameUnit then
          if (t.hadUnit or t.unlock) and recordTable.unlockCount + 1 <= #recordTable.unitInfo then
            table.insert(recordTable.unitInfo, recordTable.unlockCount + 1, t)
          else
            table.insert(recordTable.unitInfo, t)
          end
        end
        if t.unlock then
          if not isSameUnit then
            recordTable.unlockCount = recordTable.unlockCount + 1
          end
          recordTable.param = recordTable.param + t.param
        end
      end
    end
  end
  
  local bookUnitCA = PlayerData:GetFactoryData(80900001, "BookFactory")
  local isSkinSkill = PlayerData.IsSkinHomeSkillOpen()
  for k, v in ipairs(bookUnitCA.unitList) do
    local unitCA = PlayerData:GetFactoryData(v.id, "unitFactory")
    if isSkinSkill then
      for k2, v2 in ipairs(unitCA.skinList) do
        local unitViewCA = PlayerData:GetFactoryData(v2.unitViewId)
        if unitViewCA and unitViewCA.homeSkill and unitViewCA.homeSkill > 0 then
          generalAddHomeSkillFunc({
            {
              id = unitViewCA.homeSkill
            }
          }, v.id, v2.unitViewId)
        end
      end
    end
    generalAddHomeSkillFunc(unitCA.homeSkillList, v.id)
  end
  table.sort(DataModel.HomeSkillInfo, function(a, b)
    return a.homeSkillCA.sort > b.homeSkillCA.sort
  end)
end

return DataModel
