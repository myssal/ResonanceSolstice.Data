local View = require("UIWeaponCreate/UIWeaponCreateView")
local DataModel = require("UIWeaponCreate/UIWeaponCreateDataModel")
local ViewFunction = require("UIWeaponCreate/UIWeaponCreateViewFunction")
local params
local Luabehaviour = {
  serialize = function()
    return params
  end,
  deserialize = function(initParams)
    params = initParams
    DataModel.decodeParams = Json.decode(params)
    DataModel.initData(DataModel.decodeParams)
    ViewFunction.RefreshPanel()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    local npcDialog = require("Common/NPCDialog")
    npcDialog.ClearAll()
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
