local DataModel = {
  CUBE_ID = 89400002,
  bookId = 80900015,
  teamBookId = 80900017,
  QualityColor = {
    Blue = "UI/CubeRogue/QualityBG/Buff/Tiny/Blue",
    Purple = "UI/CubeRogue/QualityBG/Buff/Tiny/Purple",
    Golden = "UI/CubeRogue/QualityBG/Buff/Tiny/Golden",
    Orange = "UI/CubeRogue/QualityBG/Buff/Tiny/Orange"
  },
  QualityDecoColor = {
    Blue = "UI/CubeRogue/QualityBG/Buff/Big/Blue",
    Purple = "UI/CubeRogue/QualityBG/Buff/Big/Purple",
    Golden = "UI/CubeRogue/QualityBG/Buff/Big/Golden",
    Orange = "UI/CubeRogue/QualityBG/Buff/Big/Orange"
  },
  qualityToIndex = {
    Blue = 1,
    Purple = 2,
    Golden = 3,
    Orange = 4
  },
  quality = {
    Blue = "Blue",
    Purple = "Purple",
    Golden = "Golden",
    Orange = "Orange"
  },
  unlockBuffs = {},
  bookName = ""
}

function DataModel.GetTabListInfo()
  local bookConfig = PlayerData:GetFactoryData(DataModel.teamBookId, "BookFactory")
  if not bookConfig then
    return nil
  end
  return bookConfig.entryList
end

function DataModel.GetStageRewardList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return nil
  end
  return bookConfig.stageList
end

function DataModel.GetAllBuffList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return {}
  end
  return bookConfig.entryList or {}
end

function DataModel.GetBuffListByTab(tabId)
  local buffList = {}
  if not tabId then
    return buffList
  end
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return buffList
  end
  local entryList = bookConfig.entryList or {}
  for i = 1, #entryList do
    local buffInfo = PlayerData:GetFactoryData(entryList[i].id, "RogueBuffFactory")
    if buffInfo and buffInfo.correspondingTeam == tabId then
      table.insert(buffList, entryList[i].id)
    end
  end
  table.sort(buffList, function(a, b)
    local rogueA = PlayerData:GetFactoryData(a, "RogueBuffFactory")
    local rogueB = PlayerData:GetFactoryData(b, "RogueBuffFactory")
    local isUnlockA = DataModel.GetBuffIsUnlock(a)
    local isUnlockB = DataModel.GetBuffIsUnlock(b)
    local qualityA = DataModel.qualityToIndex[rogueA.quality]
    local qualityB = DataModel.qualityToIndex[rogueB.quality]
    if isUnlockA ~= isUnlockB then
      return isUnlockA
    elseif qualityA ~= qualityB then
      return qualityA > qualityB
    else
      return a < b
    end
  end)
  return buffList
end

function DataModel.GetBuffIsUnlock(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local buffs = PlayerData.ServerData.books.buff
  if not buffs then
    return false
  end
  return table.containsKey(buffs, tostring(id))
end

function DataModel.GetUnlockNumEnoughToGet(index)
  local stageList = DataModel.GetStageRewardList() or {}
  if not stageList[index] then
    return false
  end
  local needNum = stageList[index].num or 0
  local unlockNum = 0
  local allList = DataModel.GetAllBuffList() or {}
  for i = 1, #allList do
    local isUnlock = DataModel.GetBuffIsUnlock(allList[i].id)
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
  if not PlayerData.ServerData.books.buff_reward then
    return false
  end
  return table.contains(PlayerData.ServerData.books.buff_reward, index)
end

function DataModel.SetRewardHasGet(index)
  PlayerData.ServerData.books = PlayerData.ServerData.books or {}
  PlayerData.ServerData.books.buff_reward = PlayerData.ServerData.books.buff_reward or {}
  if not table.contains(PlayerData.ServerData.books.buff_reward, index) then
    table.insert(PlayerData.ServerData.books.buff_reward, index)
  end
end

function DataModel.GetBookItemIsNew(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local buffs = PlayerData.ServerData.books.buff
  if not buffs then
    return false
  end
  local itemInfo = buffs[tostring(id)]
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
  PlayerData.ServerData.books.buff = PlayerData.ServerData.books.buff or {}
  PlayerData.ServerData.books.buff[idStr] = PlayerData.ServerData.books.buff[idStr] or {}
  PlayerData.ServerData.books.buff[idStr].read = 1
end

function DataModel.IsIdInEntryList(id)
  local list = DataModel.GetAllBuffList() or {}
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
  if not PlayerData.ServerData.books.buff then
    return false
  end
  for id, v in pairs(PlayerData.ServerData.books.buff) do
    if id and DataModel.IsIdInEntryList(id) and (v and v.read == nil or v.read == 0) then
      return true
    end
  end
  return false
end

function DataModel.GetAllUnlockCount()
  local unlockNum = 0
  local allList = DataModel.GetAllBuffList() or {}
  for i = 1, #allList do
    local isUnlock = DataModel.GetBuffIsUnlock(allList[i].id)
    if isUnlock then
      unlockNum = unlockNum + 1
    end
  end
  return unlockNum
end

function DataModel.GetAllCount()
  local allList = DataModel.GetAllBuffList() or {}
  return #allList
end

function DataModel.GetFinishedProgressNum()
  local stageList = DataModel.GetStageRewardList() or {}
  local unlockNum = DataModel.GetAllUnlockCount()
  local nowNum = 0
  for i = 1, #stageList do
    if unlockNum >= stageList[i].num then
      nowNum = nowNum + 1
    else
      break
    end
  end
  return nowNum
end

function DataModel.GetProgressRewardRedState()
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.buff_reward then
    return false
  end
  local finishNum = DataModel.GetFinishedProgressNum() or 0
  if 0 < finishNum and finishNum > #PlayerData.ServerData.books.buff_reward then
    return true
  end
  return false
end

function DataModel.GetBookName()
  return DataModel.bookName
end

function DataModel.GetIsAllStageRewardGot()
  local stageList = DataModel.GetStageRewardList() or {}
  if #stageList == 0 then
    return false
  end
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.buff_reward then
    return false
  end
  if #PlayerData.ServerData.books.buff_reward == #stageList then
    return true
  end
  return false
end

return DataModel
