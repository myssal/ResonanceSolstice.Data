local View = require("UIPersonalProgress/UIPersonalProgressView")
local DataModel = require("UIPersonalProgress/UIPersonalProgressDataModel")
local ViewFunction = require("UIPersonalProgress/UIPersonalProgressViewFunction")
local Controller = require("UIActivityMain/BlackTeaActivityController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    Controller.RefreshPersonalStage()
    View.Group_TopLeft.Btn_Server:SetSprite(GetResPath(88300028))
    View.Group_TopLeft.Img_Personal:SetSprite(GetResPath(88300029))
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
