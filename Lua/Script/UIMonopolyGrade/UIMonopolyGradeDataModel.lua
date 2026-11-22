local DataModel = {
  lv = 1,
  exp = 0,
  nextCost = 0,
  isOpenByMap = false
}

function DataModel.InitMapGradeInfo()
  DataModel.lv = PlayerData.GetUserMonopolyLv() or 1
  DataModel.exp = PlayerData.GetUserMonopolyExp() or 0
  DataModel.nextCost = 0
  local mapId = PlayerData.GetUserMonopolyId()
  local ca = PlayerData:GetFactoryData(mapId, "MonopolyGameMapFactory")
  if not ca then
    return
  end
  local gameGradeList = ca.gameGradeList or {}
  local count = #gameGradeList
  if count > DataModel.lv + 1 then
    for i = DataModel.lv + 1, count do
      if DataModel.exp >= gameGradeList[i].exp then
        DataModel.exp = DataModel.exp - gameGradeList[i].exp
        if DataModel.exp >= 0 then
          DataModel.lv = DataModel.lv + 1
        end
      else
        break
      end
    end
  end
  DataModel.lv = count < DataModel.lv and count or DataModel.lv
  DataModel.nextCost = gameGradeList[DataModel.lv].exp
  PlayerData.SetUserMonopolyLv(DataModel.lv)
  PlayerData.SetUserMonopolyExp(DataModel.exp)
end

function DataModel.GetLv()
  return DataModel.lv
end

function DataModel.GetExp()
  return DataModel.exp
end

function DataModel.GetNextCost()
  return DataModel.nextCost
end

function DataModel.GetIsFull()
  return DataModel.isFull
end

return DataModel
