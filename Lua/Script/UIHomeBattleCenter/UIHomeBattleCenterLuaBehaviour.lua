local Timer = require("Common/Timer")
local View = require("UIHomeBattleCenter/UIHomeBattleCenterView")
local DataModel = require("UIHomeBattleCenter/UIHomeBattleCenterDataModel")
local ViewFunction = require("UIHomeBattleCenter/UIHomeBattleCenterViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local t = Json.decode(initParams)
      DataModel.param = t
      DataModel.StationId = t.stationId
      DataModel.BuildingId = t.buildingId or -1
      DataModel.NpcId = t.npcId
      DataModel.BgPath = t.bgPath
      DataModel.BgColor = t.bgColor or "FFFFFF"
      DataModel.BgColor = "#" .. DataModel.BgColor
      DataModel.StationName = t.name
      DataModel.StationList = PlayerData:GetHomeInfo().stations[tostring(t.stationId)]
      DataModel.StationState = PlayerData:GetHomeInfo().stations[tostring(t.stationId)].state
      DataModel.Index_OutSide = 1
      DataModel.noConstruction = t.noConstruction
      DataModel.Init_Group = t.initGroup
      DataModel.InitItem = t.initItem
      DataModel:Init(true)
      if t.autoShowLevel == 1 then
        DataModel:OpenBattlePage()
      end
      if DataModel.Init_Group == "Group_Sale" then
        DataModel:OpenSalePage()
      elseif DataModel.Init_Group == "Group_Exchange" then
        DataModel:OpenStorePage()
      end
    else
      DataModel:Init()
      if View.Group_Battle.self.IsActive then
        DataModel:OpenBattlePage()
      elseif View.Group_Order.self.IsActive then
        DataModel:OpenOrderPage()
      elseif View.Group_Ticket.IsActive then
        DataModel:RefreshBySelectType(DataModel.curSelectType)
      elseif View.Group_Exchange.IsActive then
        DataModel:OpenStorePage(true)
      elseif View.Group_Sale.IsActive then
        DataModel:OpenSalePage(DataModel.saleStatus)
      end
    end
  end,
  awake = function()
    View.timer = Timer.New(1, function()
      if View.Group_Order.self.IsActive == true then
        for k, v in pairs(DataModel.orderList) do
          local grid = View.Group_Order.Group_1.ScrollGrid_List.grid.self
          local element
          if grid:GetChildByIndex(k - 1) then
            element = grid:GetChildByIndex(k - 1):GetComponent(typeof(CS.Seven.UIGridItemIndex)).element
          end
          if DataModel.orderList[k] and DataModel.orderList[k].refresh_time ~= -1 then
            local time = DataModel.orderList[k].refresh_time - TimeUtil:GetServerTimeStamp()
            if 0 < time then
              if element then
                element.Group_Limit:SetActive(true)
                element.Group_Limit.Group_Time.Txt_Time:SetText(string.format(GetText(80601232), TimeUtil:SecondToTable(time).minute, TimeUtil:SecondToTable(time).second))
              end
            elseif element then
              element.Group_Limit:SetActive(false)
            end
          end
        end
      end
      if View.Group_Battle.self.IsActive and DataModel.monsterLevelAutoBattle then
        DataModel.remainAutoBattleTime = DataModel.remainAutoBattleTime - 1
        DataModel:RefreshRemainTime()
      end
    end)
  end,
  start = function()
  end,
  update = function()
    View.timer:Update()
  end,
  ondestroy = function()
    if DataModel.questRewardList then
      DataModel.questRewardList = nil
    end
    if DataModel.donateRewardItemObjList then
      for i, tbl in ipairs(DataModel.donateRewardItemObjList) do
        for _, v in ipairs(tbl) do
          Object.Destroy(v.gameObject)
        end
      end
      DataModel.donateRewardItemObjList = nil
    end
    local npcDialog = require("Common/NPCDialog")
    npcDialog.ClearAll()
  end,
  enable = function()
  end,
  disenable = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
