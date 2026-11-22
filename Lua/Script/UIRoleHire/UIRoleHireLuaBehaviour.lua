local View = require("UIRoleHire/UIRoleHireView")
local DataModel = require("UIRoleHire/UIRoleHireDataModel")
local ViewFunction = require("UIRoleHire/UIRoleHireViewFunction")
local BtnController = require("UIRoleHire/UIRoleHireController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local openData = Json.decode(initParams)
    DataModel.InitData(openData)
    BtnController:Deserialize()
    BtnController.Open_Screen_Chapter(false)
    BtnController.InitFilter()
    BtnController:Init(View.Group_TopRight.Btn_Rarity)
    BtnController.RefreshCharacterFilter()
    BtnController.ShowCoin()
    BtnController.RefreshHireBtn()
    View.Screen_Chapter_New:SetActive(false)
    View.Group_SuccessTip:SetActive(false)
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
  end,
  ondestroy = function()
    DataModel.SelectList = nil
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
