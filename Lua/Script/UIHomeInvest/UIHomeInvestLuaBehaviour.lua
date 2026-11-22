local View = require("UIHomeInvest/UIHomeInvestView")
local DataModel = require("UIHomeInvest/UIHomeInvestDataModel")
local Controller = require("UIHomeInvest/UIHomeInvestController")
local ViewFunction = require("UIHomeInvest/UIHomeInvestViewFunction")
local Luabehaviour = {
  serialize = function()
    return Json.encode(DataModel.initParams)
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local info = Json.decode(initParams)
      DataModel.initParams = info
      DataModel.StationId = info.stationId
      DataModel.BuildingId = info.buildingId
      DataModel.NpcId = info.npcId
      DataModel.BgPath = info.bgPath
      DataModel.BgColor = info.bgColor or "FFFFFF"
      DataModel.BgColor = "#" .. DataModel.BgColor
      DataModel.IsBossBattle = info.isBossBattle
      local serverStation = PlayerData:GetHomeInfo().stations[tostring(DataModel.StationId)]
      DataModel.CurRepLv = serverStation.rep_lv or 0
      Controller:Init()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
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
