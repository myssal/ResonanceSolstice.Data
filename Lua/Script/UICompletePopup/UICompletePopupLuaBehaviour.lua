local View = require("UICompletePopup/UICompletePopupView")
local DataModel = require("UICompletePopup/UICompletePopupDataModel")
local ViewFunction = require("UICompletePopup/UICompletePopupViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local activityId = Json.decode(initParams).activityId
    DataModel.activityId = activityId
    View.Img_Complete.Img_CompleteIcon:SetSprite(GetResPath(88300037))
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
