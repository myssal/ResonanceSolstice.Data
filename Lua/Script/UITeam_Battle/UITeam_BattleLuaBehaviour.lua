local View = require("UITeam_Battle/UITeam_BattleView")
local DataModel = require("UITeam_Battle/UITeam_BattleDataModel")
local ViewFunction = require("UITeam_Battle/UITeam_BattleViewFunction")
local Controller = require("UITeam_Battle/UITeam_BattleController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:SetDataModel("UITeam_Battle/UITeam_BattleDataModel")
    local isReopen = true
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.mode = data.mode
      DataModel.levelId = data.levelId
      DataModel.isReStart = data.isReStart
      isReopen = false
    end
    Controller:Init(isReopen)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
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
      View.Group_RoleTemp.self:SetLocalPosition(pos)
    end
    if not DataModel.isDrag and View.Group_RoleTemp.self.IsActive then
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
