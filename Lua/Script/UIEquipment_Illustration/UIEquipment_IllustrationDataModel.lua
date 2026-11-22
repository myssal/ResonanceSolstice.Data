local DataModel = {
  CUBE_ID = 89400002,
  bookId = 80900016,
  qualityTxt = {
    [0] = 80610265,
    [1] = 80610260,
    [2] = 80610261,
    [3] = 80610262,
    [4] = 80610263,
    [5] = 80610264
  },
  qualityBg = {
    Blue = "UI/CubeRogue/QualityBG/Buff/Tiny/Blue",
    Purple = "UI/CubeRogue/QualityBG/Buff/Tiny/Purple",
    Golden = "UI/CubeRogue/QualityBG/Buff/Tiny/Golden",
    Orange = "UI/CubeRogue/QualityBG/Buff/Tiny/Orange",
    isNegative = "UI/CubeRogue/QualityBG/Buff/Tiny/Red"
  },
  qualityDetailBg = {
    Blue = "UI/CubeRogue/QualityBG/Weapon/Big/Blue",
    Purple = "UI/CubeRogue/QualityBG/Weapon/Big/Purple",
    Golden = "UI/CubeRogue/QualityBG/Weapon/Big/Golden",
    Orange = "UI/CubeRogue/QualityBG/Weapon/Big/Orange",
    isNegative = "UI/CubeRogue/QualityBG/Weapon/Big/Red"
  },
  indexToQuality = {
    [0] = "All",
    [1] = "Blue",
    [2] = "Purple",
    [3] = "Golden",
    [4] = "Orange",
    [5] = "isNegative"
  },
  qualityToIndex = {
    Blue = 1,
    Purple = 2,
    Golden = 3,
    Orange = 4,
    isNegative = 0
  },
  curTabIndex = 1,
  curSelectQuaIndex = 0,
  bookName = ""
}

function DataModel.GetAllEquipList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return {}
  end
  return bookConfig.entryList or {}
end

function DataModel.GetEquipListByTabIndex()
  local allList = {}
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if bookConfig then
    allList = bookConfig.entryList or {}
  end
  local filterList = {}
  for i = 1, #allList do
    local rogueInfo = PlayerData:GetFactoryData(allList[i].id, "RogueEquipmentFactory")
    if rogueInfo then
      local isUnlock = DataModel.GetEquipIsUnlock(allList[i].id)
      if DataModel.curTabIndex == 1 then
        if DataModel.curSelectQuaIndex == 0 or rogueInfo.isNegative == false and rogueInfo.quality == DataModel.indexToQuality[DataModel.curSelectQuaIndex] or rogueInfo.isNegative and DataModel.curSelectQuaIndex == 5 then
          table.insert(filterList, allList[i])
        end
      elseif DataModel.curTabIndex == 2 then
        if isUnlock and (DataModel.curSelectQuaIndex == 0 or rogueInfo.isNegative == false and rogueInfo.quality == DataModel.indexToQuality[DataModel.curSelectQuaIndex] or rogueInfo.isNegative and DataModel.curSelectQuaIndex == 5) then
          table.insert(filterList, allList[i])
        end
      elseif DataModel.curTabIndex == 3 and isUnlock == false and (DataModel.curSelectQuaIndex == 0 or rogueInfo.isNegative == false and rogueInfo.quality == DataModel.indexToQuality[DataModel.curSelectQuaIndex] or rogueInfo.isNegative and DataModel.curSelectQuaIndex == 5) then
        table.insert(filterList, allList[i])
      end
    end
  end
  table.sort(filterList, function(a, b)
    local rogueA = PlayerData:GetFactoryData(a.id, "RogueEquipmentFactory")
    local rogueB = PlayerData:GetFactoryData(b.id, "RogueEquipmentFactory")
    local isUnlockA = DataModel.GetEquipIsUnlock(a.id)
    local isUnlockB = DataModel.GetEquipIsUnlock(b.id)
    local qualityA = rogueA.isNegative and 0 or DataModel.qualityToIndex[rogueA.quality]
    local qualityB = rogueB.isNegative and 0 or DataModel.qualityToIndex[rogueB.quality]
    if isUnlockA ~= isUnlockB then
      return isUnlockA
    elseif qualityA ~= qualityB then
      return qualityA > qualityB
    else
      return a.id < b.id
    end
  end)
  return filterList
end

function DataModel.GetStageList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return nil
  end
  return bookConfig.stageList
end

function DataModel.GetBookTypeName()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return ""
  end
  return bookConfig.typeName or ""
end

function DataModel.GetBookName()
  return DataModel.bookName
end

function DataModel.GetEquipIsUnlock(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local equips = PlayerData.ServerData.books.cube_equip
  if not equips then
    return false
  end
  return table.containsKey(equips, tostring(id))
end

function DataModel.GetUnlockNumEnoughToGet(index)
  local stageList = DataModel.GetStageList() or {}
  if not stageList[index] then
    return false
  end
  local needNum = stageList[index].num or 0
  local unlockNum = 0
  local allList = DataModel.GetAllEquipList() or {}
  for i = 1, #allList do
    local isUnlock = DataModel.GetEquipIsUnlock(allList[i].id)
    if isUnlock then
      unlockNum = unlockNum + 1
    end
  end
  return needNum <= unlockNum
end

function DataModel.GetRewardIsGetByIndex(index)
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.ce_reward then
    return false
  end
  return table.contains(PlayerData.ServerData.books.ce_reward, index)
end

function DataModel.SetRewardHasGet(index)
  PlayerData.ServerData.books = PlayerData.ServerData.books or {}
  PlayerData.ServerData.books.ce_reward = PlayerData.ServerData.books.ce_reward or {}
  if not table.contains(PlayerData.ServerData.books.ce_reward, index) then
    table.insert(PlayerData.ServerData.books.ce_reward, index)
  end
end

function DataModel.GetBookItemIsNew(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local equips = PlayerData.ServerData.books.cube_equip
  if not equips then
    return false
  end
  local itemInfo = equips[tostring(id)]
  if not itemInfo then
    return false
  end
  return itemInfo.read == nil or itemInfo.read == 0
end

function DataModel.SetBookItemIsNotNew(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local idStr = tostring(id)
  PlayerData.ServerData.books.cube_equip = PlayerData.ServerData.books.cube_equip or {}
  PlayerData.ServerData.books.cube_equip[idStr] = PlayerData.ServerData.books.cube_equip[idStr] or {}
  PlayerData.ServerData.books.cube_equip[idStr].read = 1
end

function DataModel.IsIdInEntryList(id)
  local list = DataModel.GetAllEquipList() or {}
  for i = 1, #list do
    if tostring(list[i].id) == id then
      return true
    end
  end
  return false
end

function DataModel.GetBookIsHasNewItem()
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.cube_equip then
    return false
  end
  for id, v in pairs(PlayerData.ServerData.books.cube_equip) do
    if id and DataModel.IsIdInEntryList(id) and (v and v.read == nil or v.read == 0) then
      return true
    end
  end
  return false
end

function DataModel.GetAllUnlockCount()
  local unlockNum = 0
  local allList = DataModel.GetAllEquipList() or {}
  for i = 1, #allList do
    local isUnlock = DataModel.GetEquipIsUnlock(allList[i].id)
    if isUnlock then
      unlockNum = unlockNum + 1
    end
  end
  return unlockNum
end

function DataModel.GetAllCount()
  local allList = DataModel.GetAllEquipList() or {}
  return #allList
end

function DataModel.GetFinishedProgressNum()
  local stageList = DataModel.GetStageList() or {}
  local unlockNum = DataModel.GetAllUnlockCount() or 0
  local nowNum = 0
  for i = 1, #stageList do
    if unlockNum >= stageList[i].num then
      nowNum = nowNum + 1
    end
  end
  return nowNum
end

function DataModel.GetProgressRewardRedState()
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.ce_reward then
    return false
  end
  local finishNum = DataModel.GetFinishedProgressNum() or 0
  if 0 < finishNum and finishNum > #PlayerData.ServerData.books.ce_reward then
    return true
  end
  return false
end

function DataModel.GetIsAllStageRewardGot()
  local stageList = DataModel.GetStageList() or {}
  if #stageList == 0 then
    return false
  end
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.ce_reward then
    return false
  end
  if #PlayerData.ServerData.books.ce_reward == #stageList then
    return true
  end
  return false
end

return DataModel
