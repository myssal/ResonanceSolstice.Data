local View = require("UIWitchMain/UIWitchMainView")
local DataModel = require("UIWitchMain/UIWitchMainDataModel")
local ViewFunction = require("UIWitchMain/UIWitchMainViewFunction")
local DataController = require("UIWitchMain/UIWitchMainDataController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.SetJsonData(initParams)
    if not DataModel.isInited then
      DataModel:InitData()
      DataController:Init()
    else
      DataModel.RefreshOnShow()
    end
    if WitchData.BossReward then
      local UIMainFinishDataModel = require("UIMainFinish/UIMainFinishDataModel")
      UIManager:Open(WitchData.GetUIPath("UI/Witches/Main/SettleAccount"), Json.encode({
        win = 1,
        bossReward = WitchData.BossReward
      }), UIMainFinishDataModel.ReturnHome)
      WitchData.BossReward = nil
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    if DataModel.isInited == true then
      DataController:OnUpdate()
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
