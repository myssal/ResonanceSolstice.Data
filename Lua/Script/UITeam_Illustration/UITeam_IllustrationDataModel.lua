local DataModel = {
  CUBE_ID = 89400002,
  bookId = 80900017,
  bookName = ""
}

function DataModel.GetEntryList()
  local bookConfig = PlayerData:GetFactoryData(DataModel.bookId, "BookFactory")
  if not bookConfig then
    return nil
  end
  return bookConfig.entryList
end

function DataModel.GetAllCount()
  local allList = DataModel.GetEntryList() or {}
  return #allList
end

function DataModel.GetEntryInfoByIndex(index)
  local entryList = DataModel.GetEntryList()
  if not entryList then
    return nil
  end
  local id = 0
  if entryList[index] then
    id = entryList[index].id
  end
  local rogueTeamConfig = PlayerData:GetFactoryData(id, "RogueTeamFactory")
  return rogueTeamConfig
end

function DataModel.GetBookName()
  return DataModel.bookName
end

function DataModel.GetIsAllStageRewardGot()
  return false
end

return DataModel
