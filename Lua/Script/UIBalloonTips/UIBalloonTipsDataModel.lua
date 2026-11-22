local DataModel = {}

function DataModel:ResetData()
  DataModel.TrainEventId = nil
  DataModel.TrainLineId = nil
  DataModel.Cfg = nil
  DataModel.BalloonItemId = nil
  DataModel.IsRward = nil
  DataModel.CurrNum = nil
  DataModel.MaxNum = nil
  DataModel.IsRefreshSlider = nil
  DataModel.TrainEventAreaId = nil
  DataModel.ServerNum = nil
end

function DataModel:InitData(param)
  if param then
    local basic = Json.decode(param)
    DataModel.TrainEventId = basic.eventId
    DataModel.TrainLineId = basic.lineId
    if basic.areaId then
      DataModel.TrainEventAreaId = basic.areaId
    end
    DataModel.BalloonItemId = basic.itemId
    DataModel.IsRward = basic.isReward
  else
    error("\230\178\161\230\156\137\231\129\171\232\189\166\228\186\139\228\187\182id\239\188\140\228\184\141\229\144\136\231\144\134")
  end
  local cfg = PlayerData:GetFactoryData(99900014, "ConfigFactory")
  DataModel.Cfg = cfg
  DataModel.CurrNum = 1
  DataModel.ServerNum = PlayerData:GetItemById(DataModel.BalloonItemId).num
  local currIndex = 1
  if DataModel.TrainEventAreaId and PlayerData.pollute_areas and table.count(PlayerData.pollute_areas) > 0 then
    local t = PlayerData.pollute_areas[tostring(DataModel.TrainEventAreaId)]
    currIndex = t.po_curIndex and tonumber(t.po_curIndex) + 1 or 1
  end
  local cfg = PlayerData:GetFactoryData(99900043, "ConfigFactory")
  local balloonCfg = cfg.polluteBalloonList[currIndex]
  local listId = balloonCfg.id
  local listCfg = PlayerData:GetFactoryData(listId, "ListFactory")
  DataModel.MaxNum = math.min(#listCfg.balloonList, DataModel.ServerNum)
end

function DataModel:SetCurrNum(num)
  DataModel.CurrNum = num
end

function DataModel:SetSliderRefreshState(state)
  self.IsRefreshSlider = state
end

return DataModel
