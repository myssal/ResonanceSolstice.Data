local DataModel = {
  CUBE_ID = 89400002,
  bookId = 80900020,
  curTabIndex = 1,
  bookName = ""
}

function DataModel.GetAllEventList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return {}
  end
  return bookConfig.entryList or {}
end

function DataModel.GetBookTypeName()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return ""
  end
  return bookConfig.typeName or ""
end

function DataModel.GetEventListByTabIndex()
  local allList = {}
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if bookConfig then
    allList = bookConfig.entryList or {}
  end
  local filterList = {}
  for i = 1, #allList do
    local rogueInfo = PlayerData:GetFactoryData(allList[i].id, "RogueEventFactory")
    if rogueInfo then
      local isUnlock = DataModel.GetEventIsUnlock(allList[i].id)
      if DataModel.curTabIndex == 1 then
        table.insert(filterList, allList[i])
      elseif DataModel.curTabIndex == 2 then
        if isUnlock then
          table.insert(filterList, allList[i])
        end
      elseif DataModel.curTabIndex == 3 and isUnlock == false then
        table.insert(filterList, allList[i])
      end
    end
  end
  local unlockList = {}
  local lockList = {}
  for i = 1, #filterList do
    if DataModel.GetEventIsUnlock(filterList[i].id) then
      table.insert(unlockList, filterList[i])
    else
      table.insert(lockList, filterList[i])
    end
  end
  local finalList = {}
  for i = 1, #unlockList do
    table.insert(finalList, unlockList[i])
  end
  for i = 1, #lockList do
    table.insert(finalList, lockList[i])
  end
  return finalList
end

function DataModel.GetStageList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return nil
  end
  return bookConfig.stageList
end

function DataModel.GetEventIsUnlock(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local events = PlayerData.ServerData.books.event
  if not events then
    return false
  end
  return table.containsKey(events, tostring(id))
end

function DataModel.GetUnlockNumEnoughToGet(index)
  local stageList = DataModel.GetStageList() or {}
  if not stageList[index] then
    return false
  end
  local needNum = stageList[index].num or 0
  local unlockNum = 0
  local allList = DataModel.GetAllEventList() or {}
  for i = 1, #allList do
    local isUnlock = DataModel.GetEventIsUnlock(allList[i].id)
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
  if not PlayerData.ServerData.books.event_reward then
    return false
  end
  return table.contains(PlayerData.ServerData.books.event_reward, index)
end

function DataModel.SetRewardHasGet(index)
  PlayerData.ServerData.books = PlayerData.ServerData.books or {}
  PlayerData.ServerData.books.event_reward = PlayerData.ServerData.books.event_reward or {}
  if not table.contains(PlayerData.ServerData.books.event_reward, index) then
    table.insert(PlayerData.ServerData.books.event_reward, index)
  end
end

function DataModel.GetBookItemIsNew(id)
  if not PlayerData.ServerData.books then
    return false
  end
  local events = PlayerData.ServerData.books.event
  if not events then
    return false
  end
  local itemInfo = events[tostring(id)]
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
  PlayerData.ServerData.books.event = PlayerData.ServerData.books.event or {}
  PlayerData.ServerData.books.event[idStr] = PlayerData.ServerData.books.event[idStr] or {}
  PlayerData.ServerData.books.event[idStr].read = 1
end

function DataModel.IsIdInEntryList(id)
  local list = DataModel.GetAllEventList() or {}
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
  if not PlayerData.ServerData.books.event then
    return false
  end
  for id, v in pairs(PlayerData.ServerData.books.event) do
    if id and DataModel.IsIdInEntryList(id) and (v and v.read == nil or v.read == 0) then
      return true
    end
  end
  return false
end

function DataModel.GetAllUnlockCount()
  local unlockNum = 0
  local allList = DataModel.GetAllEventList() or {}
  for i = 1, #allList do
    local isUnlock = DataModel.GetEventIsUnlock(allList[i].id)
    if isUnlock then
      unlockNum = unlockNum + 1
    end
  end
  return unlockNum
end

function DataModel.GetAllCount()
  local allList = DataModel.GetAllEventList() or {}
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
  if not PlayerData.ServerData.books.event_reward then
    return false
  end
  local finishNum = DataModel.GetFinishedProgressNum() or 0
  if 0 < finishNum and finishNum > #PlayerData.ServerData.books.event_reward then
    return true
  end
  return false
end

function DataModel.GetBookName()
  return DataModel.bookName
end

function DataModel.GetIsAllStageRewardGot()
  local stageList = DataModel.GetStageList() or {}
  if #stageList == 0 then
    return false
  end
  if not PlayerData.ServerData.books then
    return false
  end
  if not PlayerData.ServerData.books.event_reward then
    return false
  end
  if #PlayerData.ServerData.books.event_reward == #stageList then
    return true
  end
  return false
end

return DataModel
