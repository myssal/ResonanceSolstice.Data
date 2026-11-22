local View = require("UIGroup_Weapon/UIGroup_WeaponView")
local DataModel = require("UIGroup_Weapon/UIGroup_WeaponDataModel")
local Controller = require("UIGroup_Weapon/UIGroup_WeaponController")
local ViewFunction = require("UIGroup_Weapon/UIGroup_WeaponViewFunction")
local param_t = {}
local Luabehaviour = {
  serialize = function()
    return Json.encode(param_t)
  end,
  deserialize = function(initParams)
    local param = Json.decode(initParams)
    param_t = param
    DataModel:InitDta(param)
    Controller:Init()
    View.Group_Center.Btn_Detail.self:SetActive(false)
    View.Group_Center.Group_Compare.self:SetActive(false)
    local showHomeBtn = not MapNeedleEventData.scene and not WitchData.inWitchMap
    View.Group_CommonTopLeft.Btn_Home:SetActive(showHomeBtn)
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
