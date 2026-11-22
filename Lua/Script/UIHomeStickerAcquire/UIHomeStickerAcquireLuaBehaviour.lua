local View = require("UIHomeStickerAcquire/UIHomeStickerAcquireView")
local DataModel = require("UIHomeStickerAcquire/UIHomeStickerAcquireDataModel")
local ViewFunction = require("UIHomeStickerAcquire/UIHomeStickerAcquireViewFunction")
local controller = require("UIHomeStickerAcquire/UIHomeStickerAcquireController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local status = {}
    if initParams ~= nil and initParams ~= "" then
      status = Json.decode(initParams)
    end
    DataModel.Data = PlayerData:SortShowItem(status)
    table.sort(DataModel.Data, function(e1, e2)
      local factoryName1 = DataManager:GetFactoryNameById(e1.id)
      local factoryName2 = DataManager:GetFactoryNameById(e2.id)
      local sort1 = factoryName1 == "ProfilePhotoFactory" and 1 or 0
      local sort2 = factoryName2 == "ProfilePhotoFactory" and 1 or 0
      return sort1 > sort2
    end)
    DataModel.DataIndex = 1
    controller:Init()
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
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
