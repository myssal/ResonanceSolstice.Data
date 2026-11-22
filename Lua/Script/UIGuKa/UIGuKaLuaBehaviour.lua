local View = require("UIGuKa/UIGuKaView")
local DataModel = require("UIGuKa/UIGuKaDataModel")
local ViewFunction = require("UIGuKa/UIGuKaViewFunction")
local Controller = require("UIGuKa/UIGuKaController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    Controller:Init()
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(false)
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
  end,
  enable = function()
  end,
  disenable = function()
    if table.count(DataModel.GuKaImgItems) > 0 then
      for i, v in pairs(DataModel.GuKaImgItems) do
        Object.Destroy(v)
      end
    end
    DataModel.GuKaImgItems = {}
    local MainDataModel = require("UIWitchMain/UIWitchMainDataModel")
    MainDataModel.CheckGuKaRedPoint()
    local DataController = require("UIWitchMain/UIWitchMainDataController")
    DataController:SetCameraActive(true)
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
