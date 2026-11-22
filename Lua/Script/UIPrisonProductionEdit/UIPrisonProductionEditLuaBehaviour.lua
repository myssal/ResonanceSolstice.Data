local View = require("UIPrisonProductionEdit/UIPrisonProductionEditView")
local DataModel = require("UIPrisonProductionEdit/UIPrisonProductionEditDataModel")
local ViewFunction = require("UIPrisonProductionEdit/UIPrisonProductionEditViewFunction")
local Controller = require("UIPrisonProductionEdit/UIPrisonProductionEditController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.CurRoomIndex = PrisonData.roomIndex
    Controller:Init()
    if PrisonData.jumpReturnRoomIndex then
      PrisonController.JumpReturnCallBack(PrisonData.jumpReturnRoomIndex, View.self)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local needFresh = false
    for i, v in pairs(DataModel.CountDownHandler) do
      local remainTime = v.finishTime - TimeUtil:GetServerTimeStamp()
      if remainTime <= -1 then
        needFresh = true
        break
      else
        local timeTbl = TimeUtil:SecondToTable(remainTime)
        v.ctr:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
      end
    end
    if needFresh then
      Controller:RefreshWorkPlacedElement()
    end
  end,
  ondestroy = function()
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
