local View = require("UIHomeCoach/UIHomeCoachView")
local DataModel = require("UIHomeCoach/UIHomeCoachDataModel")
local ViewFunction = require("UIHomeCoach/UIHomeCoachViewFunction")
local Controller = require("UIHomeCoach/UIHomeCoachController")
local Luabehaviour = {
  serialize = function()
    if DataModel.initParams then
      return Json.encode(DataModel.initParams)
    end
  end,
  deserialize = function(initParams)
    if initParams == nil then
      DataModel.initParams = nil
      DataModel.coachBagTagId = 12601230
    else
      DataModel.initParams = Json.decode(initParams)
      local ca = PlayerData:GetFactoryData(DataModel.initParams.playgroundId)
      DataModel.coachBagTagId = ca.bag
    end
    DataModel.init = true
    DataModel.tempPanel = nil
    local homeConfig = PlayerData:GetFactoryData(99900014, "ConfigFactory")
    HomeSceneManager:ShowOutScene(false)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.init == true then
      DataModel.init = false
      View.Group_Decorate.Group_Warehouse.Group_PresetSave.InputField_Name.self:SetCharacterLimit(DataModel.characterMaxLimit)
      View.Group_Decorate.Group_Warehouse.Group_PresetTips.Group_ChangeName.InputField_ChangeName.self:SetCharacterLimit(DataModel.characterMaxLimit)
      Controller:Init()
    end
  end,
  ondestroy = function()
    View.self:PlayAnim("coach_out")
    HomeSceneManager:ShowOutScene(true)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
