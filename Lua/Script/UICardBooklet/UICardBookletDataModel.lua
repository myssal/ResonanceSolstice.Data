local DataModel = {}

function DataModel.Init(grid)
  local cardPackList = PlayerData:GetFactoryData(99900065).cardPackList
  DataModel.cardPackList = {}
  DataModel.cardOwnCnt = 0
  DataModel.cardAllCnt = 0
  DataModel.redInfo = {count = 0}
  local currentTimeStamp = TimeUtil.GetServerTimeStamp()
  local startCount = 0
  for i, v in ipairs(cardPackList) do
    if currentTimeStamp >= TimeUtil:TimeStamp(v.startTime) then
      startCount = startCount + 1
      local info = DataModel.GetCardPackInfo(v.id)
      DataModel.cardPackList[startCount] = {
        id = v.id,
        ownCount = info.ownCount,
        allCount = info.allCount
      }
      DataModel.cardOwnCnt = DataModel.cardOwnCnt + info.ownCount
      DataModel.cardAllCnt = DataModel.cardAllCnt + info.allCount
      if info.allCount - info.ownCount == 1 then
        DataModel.redInfo[v.id] = true
        DataModel.redInfo.count = DataModel.redInfo.count + 1
      end
    end
  end
  DataModel.cardPackCount = startCount + 2
  DataModel.itemSpacex = grid.Spacing.x
  DataModel.itemWidth = grid.CellSize.x
  DataModel.paddingLeft = grid.Padding.left
  DataModel.cardDataList = {}
end

function DataModel.CardIsOwn(cardId)
  local isOwn = false
  local cardList = PlayerData.ServerData.books.card_pack or {}
  if cardList[tostring(cardId)] then
    isOwn = true
  end
  return isOwn
end

function DataModel.GetCardPackInfo(cardPackId)
  local ownCount = 0
  local allCount = 0
  local cfg = PlayerData:GetFactoryData(cardPackId)
  for i, v in ipairs(cfg.otherCardList) do
    if DataModel.CardIsOwn(v.id) then
      ownCount = ownCount + 1
    end
    allCount = allCount + 1
  end
  allCount = allCount + 1
  if DataModel.CardIsOwn(cfg.topCard) then
    ownCount = ownCount + 1
  end
  local extraCardStatus = 0
  if 1 < allCount - ownCount then
    extraCardStatus = 0
  elseif allCount - ownCount == 1 then
    extraCardStatus = 1
  else
    extraCardStatus = 2
  end
  local info = {
    ownCount = ownCount,
    allCount = allCount,
    extraCardStatus = extraCardStatus
  }
  return info
end

function DataModel.UpdateNowPack(index)
  local data = DataModel.cardPackList[index]
  if data then
    local info = DataModel.GetCardPackInfo(data.id)
    local addCount = info.ownCount - data.ownCount
    data.ownCount = info.ownCount
    data.allCount = info.allCount
    DataModel.cardOwnCnt = DataModel.cardOwnCnt + addCount
  end
end

function DataModel.SetCardList()
  if next(DataModel.cardDataList) then
    return
  end
  local cardPackList = PlayerData:GetFactoryData(99900065).cardPackList
  local index = 0
  local itemHeight1 = 472
  local itemHeight2 = 352
  local spaceX = 20
  local top = 20
  local bottom = 360
  local currentTimeStamp = TimeUtil.GetServerTimeStamp()
  for i, v in ipairs(cardPackList) do
    if currentTimeStamp >= TimeUtil:TimeStamp(v.startTime) then
      local cardPackId = v.id
      local cfg = PlayerData:GetFactoryData(cardPackId)
      local count = 0
      local cardList = {}
      table.insert(cardList, cfg.topCard)
      count = count + 1
      for i, v in ipairs(cfg.otherCardList) do
        count = count + 1
        table.insert(cardList, v.id)
      end
      local maxNum = 7
      local row = math.ceil(count / maxNum)
      for i = 1, row do
        local pos = DataModel.cardDataList[index] and DataModel.cardDataList[index].pos or 0
        index = index + 1
        if i == 1 then
          if index == 1 then
            pos = 0
            pos = -top
          else
            pos = pos - itemHeight1 - spaceX
          end
        else
          pos = pos - itemHeight2 - spaceX
        end
        local data = {
          list = {},
          cardPackId = cardPackId,
          ShowTitle = i == 1,
          pos = pos,
          id = index
        }
        for i2 = 1, maxNum do
          table.insert(data.list, cardList[i2 + (i - 1) * maxNum])
        end
        DataModel.cardDataList[index] = data
      end
    end
  end
  if 0 < index then
    DataModel.height = -DataModel.cardDataList[index].pos + itemHeight1 + 191
    DataModel.height = -DataModel.cardDataList[index].pos + itemHeight1 + bottom
  end
end

function DataModel.FindCardPackDataByPackId(PackId)
  for i, v in ipairs(DataModel.cardPackList) do
    if v.id == PackId then
      return v
    end
  end
end

function DataModel.CheckRed()
  local cardPackList = PlayerData:GetFactoryData(99900065).cardPackList or {}
  for k, v in pairs(cardPackList) do
    local cardPackId = v.id
    local cfg = PlayerData:GetFactoryData(cardPackId)
    if not DataModel.CardIsOwn(cfg.topCard) then
      local isRed = true
      for i, v1 in ipairs(cfg.otherCardList) do
        if not DataModel.CardIsOwn(v1.id) then
          isRed = false
        end
      end
      if isRed then
        return true
      end
    end
  end
  return false
end

return DataModel
