local View = require("UITeam_Abyss/UITeam_AbyssView")
local DataModel = require("UITeam_Abyss/UITeam_AbyssDataModel")
local ViewFunction = require("UITeam_Abyss/UITeam_AbyssViewFunction")
local Controller = require("UITeam_Abyss/UITeam_AbyssController")
local Luabehaviour = {
  serialize = function()
    local status = {
      turntableId = DataModel.turntableId,
      activityId = DataModel.activityId,
      abyssId = DataModel.abyssId,
      periodId = DataModel.periodId,
      teamKey = DataModel.teamKey
    }
    return Json.encode(status)
  end,
  deserialize = function(initParams)
    Controller:SetUIScript("UITeam_Abyss/UITeam_AbyssDataModel", "UITeam_Abyss/UITeam_AbyssView")
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.turntableId = data.turntableId
      DataModel.abyssId = data.abyssId
      DataModel.activityId = data.activityId
      DataModel.periodId = data.periodId
      DataModel.teamKey = data.teamKey or data.abyssId
      Controller:Init()
      View.self:PlayAnimOnce("Animation_in", function()
        View.self:SetAlpha(1)
      end)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    DataModel.remainTime = DataModel.remainTime - 0.02
    if DataModel.remainTime <= 0 then
      DataModel.remainTime = DataModel.constTime
      if DataModel.periodId then
        local curPeriodCA = PlayerData:GetFactoryData(DataModel.periodId)
        if not TimeUtil:IsActive(curPeriodCA.startTime, curPeriodCA.endTime) then
          UIManager:GoBack()
        end
      end
    end
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
