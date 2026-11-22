local View = require("UIPrisonMain/UIPrisonMainView")
local DataModel = require("UIPrisonMain/UIPrisonMainDataModel")
local ViewFunction = require("UIPrisonMain/UIPrisonMainViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams then
      DataModel.SetJsonData(initParams)
    end
    DataModel.InitData()
    DataModel.RefreshOnShow()
    if PrisonData.jumpReturnRoomIndex then
      PrisonController.JumpReturnCallBack(PrisonData.jumpReturnRoomIndex, View.self)
    end
  end,
  awake = function()
  end,
  start = function()
  end,
  update = function()
    PrisonController.UpdateProductBubble()
    PrisonController.UpdatePrisonerAnimEvent()
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
