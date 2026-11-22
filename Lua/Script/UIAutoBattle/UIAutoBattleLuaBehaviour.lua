local View = require("UIAutoBattle/UIAutoBattleView")
local DataModel = require("UIAutoBattle/UIAutoBattleDataModel")
local ViewFunction = require("UIAutoBattle/UIAutoBattleViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.IsChanged = false
    DataModel.teamKey = ""
    DataModel.roleList = {}
    local showHomeBtn = not MapNeedleEventData.scene and not WitchData.inWitchMap
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.isInBattle = data.isInBattle
      local isReStart = PlayerData.SquadsTempData and PlayerData.SquadsTempData.IsReStart or false
      showHomeBtn = showHomeBtn and data.isInBattle ~= true and isReStart ~= true and data.isHideHome ~= true
      ViewFunction.SetTeamData(data.teamKey, data.roleList, data.header)
      DataModel.tempRoles = data.usableRoles
    end
    ViewFunction:RefreshAll()
    View.Group_TopBar.Group_CommonTopLeft.Btn_Home:SetActive(showHomeBtn)
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
      local pos = ViewFunction:GetMousePos()
      View.Group_CardTemp.self:SetLocalPosition(pos)
      ViewFunction:Draging()
    end
    if not DataModel.isDrag and View.Group_CardTemp.self.IsActive then
      ViewFunction:DragEnd()
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
