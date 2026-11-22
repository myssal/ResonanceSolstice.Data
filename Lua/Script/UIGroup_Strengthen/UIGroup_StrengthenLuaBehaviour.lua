local View = require("UIGroup_Strengthen/UIGroup_StrengthenView")
local DataModel = require("UIGroup_Strengthen/UIGroup_StrengthenDataModel")
local Controller = require("UIGroup_Strengthen/UIGroup_StrengthenController")
local ViewFunction = require("UIGroup_Strengthen/UIGroup_StrengthenViewFunction")
local Luabehaviour = {
  serialize = function()
    return DataModel.initParams
  end,
  deserialize = function(initParams)
    DataModel.initParams = initParams
    local param = Json.decode(initParams)
    DataModel:Init(param)
    Controller:Init()
    Controller:RefreshRightContent()
    DataModel.delay_ani_time = -1
    DataModel.AniState = false
    if MapNeedleEventData.scene then
      View.Group_CommonTopLeft.Btn_Home:SetActive(false)
    end
    if WitchData.inWitchMap then
      View.Group_CommonTopLeft.Btn_Home:SetActive(false)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    if DataModel.AniState == false then
      return
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
