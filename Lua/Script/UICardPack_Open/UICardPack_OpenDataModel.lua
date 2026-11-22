local DataModel = {}

function DataModel.Init(data)
  DataModel.cardPackId = data.cardPackId
  DataModel.activityName = data.activityName
  local cfg = PlayerData:GetFactoryData(data.cardPackId)
  DataModel.cardBackBg = cfg.cardBack
  DataModel.cardList = cfg.otherCardList
  DataModel.extraCardId = cfg.topCard
  DataModel.effectPath = cfg.effect
  DataModel.isCardBooklet = data.isCardBooklet
  DataModel.pageIdx = 1
  DataModel.pageCardMaxNum = 6
  DataModel.cardNum = #DataModel.cardList
  DataModel.pageNum = DataModel.cardNum <= DataModel.pageCardMaxNum and 1 or math.ceil((DataModel.cardNum - 6) / 12) + 1
  DataModel.ignoreDrag = false
  DataModel.page2Order = nil
  DataModel.page3Order = nil
end

function DataModel.CardIsOwn(cardId)
  local isOwn = false
  local cardList = PlayerData.ServerData.books.card_pack or {}
  if cardList[tostring(cardId)] then
    isOwn = true
  end
  return isOwn
end

function DataModel.GetCardId(idx, pageIdx)
  local realIdx = idx + (pageIdx - 1) * DataModel.pageCardMaxNum
  local cardId
  if DataModel.cardList[realIdx] then
    cardId = DataModel.cardList[realIdx].id
  end
  return cardId
end

function DataModel.SetPageIdx(idx)
  DataModel.pageIdx = idx
end

function DataModel.GetAnimatorIdx()
  if DataModel.pageIdx == 1 then
    return 1
  end
  if DataModel.pageIdx % 2 == 0 then
    return 2
  end
  if DataModel.pageIdx % 2 == 1 then
    return 3
  end
end

function DataModel.GetPageCardNum(leftPage)
  local leftIdx = leftPage and DataModel.pageIdx * 2 + 1 or DataModel.pageIdx * 2 - 3
  local rightIdx = leftPage and DataModel.pageIdx * 2 or DataModel.pageIdx * 2 - 4
  local leftMaxNum = DataModel.pageCardMaxNum
  local rightMaxNum = DataModel.pageCardMaxNum
  leftMaxNum = DataModel.cardNum >= leftIdx * DataModel.pageCardMaxNum and DataModel.pageCardMaxNum or DataModel.cardNum - (leftIdx - 1) * DataModel.pageCardMaxNum
  rightMaxNum = DataModel.cardNum >= rightIdx * DataModel.pageCardMaxNum and DataModel.pageCardMaxNum or DataModel.cardNum - (rightIdx - 1) * DataModel.pageCardMaxNum
  return leftMaxNum, rightMaxNum
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

return DataModel
