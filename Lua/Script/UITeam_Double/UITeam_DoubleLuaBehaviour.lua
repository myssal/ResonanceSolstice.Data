local View = require("UITeam_Double/UITeam_DoubleView")
local DataModel = require("UITeam_Double/UITeam_DoubleDataModel")
local ViewFunction = require("UITeam_Double/UITeam_DoubleViewFunction")
local Controller = require("UITeam_Abyss/UITeam_AbyssController")
local Luabehaviour = {
  serialize = function()
    local status = {
      abyssId = DataModel.abyssId,
      periodId = DataModel.periodId,
      isDoubleTeam = DataModel.isDoubleTeam,
      callBackPage = DataModel.battleCallBackPage,
      teamKey = DataModel.teamKey,
      pathBtnBattle = DataModel.pathBtnBattle,
      numText = DataModel.numText,
      difficulty = DataModel.difficulty,
      extraUIParamData = DataModel.extraUIParamData
    }
    return Json.encode(status)
  end,
  deserialize = function(initParams)
    Controller:SetUIScript("UITeam_Double/UITeam_DoubleDataModel", "UITeam_Double/UITeam_DoubleView")
    if initParams ~= nil then
      local data = Json.decode(initParams)
      DataModel.abyssId = data.abyssId
      DataModel.periodId = data.periodId
      DataModel.isDoubleTeam = data.isDoubleTeam
      DataModel.teamKey = data.teamKey or data.abyssId
      DataModel.pathBtnBattle = data.pathBtnBattle
      DataModel.numText = data.numText
      if data.callBackPage then
        DataModel.battleCallBackPage = data.callBackPage
      end
      if data.difficulty then
        DataModel.difficulty = data.difficulty
      end
      Controller:Init()
      View.self:PlayAnimOnce("Animation_in", function()
        View.self:SetAlpha(1)
      end)
      if data.extraUIParamData then
        DataModel.extraUIParamData = data.extraUIParamData
      end
      if data.isAutoBattle == true then
        local success = Controller:TryBattle()
        if success == false then
          PlayerData.TempCache.MonsterLevelAutoBattle = false
        end
      end
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
