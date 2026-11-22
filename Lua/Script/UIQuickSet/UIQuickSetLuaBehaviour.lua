local View = require("UIQuickSet/UIQuickSetView")
local DataModel = require("UIQuickSet/UIQuickSetDataModel")
local ViewFunction = require("UIQuickSet/UIQuickSetViewFunction")
local Controller = require("UIQuickSet/UIQuickSetController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:init()
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
      local pos = Controller:GetMousePos()
      View.Group_RowTemp.self:SetLocalPosition(pos)
      Controller:Draging()
    end
    if not DataModel.isDrag and View.Group_RowTemp.self.IsActive then
      Controller:DragEnd()
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
