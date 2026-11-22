local View = require("UIPrisonEdit/UIPrisonEditView")
local DataModel = require("UIPrisonEdit/UIPrisonEditDataModel")
local ViewFunction = require("UIPrisonEdit/UIPrisonEditViewFunction")
local Controller = require("UIPrisonEdit/UIPrisonEditController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil and initParams ~= "" then
      local data = Json.decode(initParams)
      DataModel.CurRoomIndex = data.roomIndex
      DataModel.CurSelectWorkerIndex = data.selectWorkerIndex
      Controller:Init()
    else
      UIManager:GoBack()
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    local down = false
    if Input.GetMouseButton(0) then
      down = true
    end
    DataModel.curFrameMouseDown = false
    DataModel.curFrameMouseUp = false
    if DataModel.preMouseDown ~= down then
      if DataModel.preMouseDown == false then
        DataModel.curFrameMouseDown = true
      else
        DataModel.curFrameMouseUp = true
      end
    end
    DataModel.preMouseDown = down
    if DataModel.curFrameMouseUp then
      DataModel.isDrag = false
    end
    if DataModel.isDrag then
      local pos = Input.mousePosition
      View.Group_Temp.self:SetAnchoredPosition(Vector2(pos.x, pos.y))
      Controller:Dragging()
    end
    if not DataModel.isDrag and View.Group_Temp.self.IsActive then
      Controller:DragEnd()
    end
    local needFresh = false
    for i, v in pairs(DataModel.CountDownHandler) do
      local remainTime = v.finishTime - TimeUtil:GetServerTimeStamp()
      if remainTime <= -1 then
        needFresh = true
        break
      else
        local timeTbl = TimeUtil:SecondToTable(remainTime)
        v.ctr1:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
        v.ctr2:SetText(string.format("%02d:%02d:%02d", timeTbl.hour, timeTbl.minute, timeTbl.second))
      end
    end
    if needFresh then
      Controller:RefreshAllWorkerListElement()
    end
  end,
  ondestroy = function()
  end,
  enable = function()
  end,
  disenable = function()
    for i, v in pairs(DataModel.UpgradeEffList) do
      Object.Destroy(v)
    end
    DataModel.UpgradeEffList = {}
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
