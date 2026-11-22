local View = require("UIServerProgress/UIServerProgressView")
local DataModel = require("UIServerProgress/UIServerProgressDataModel")
local ViewFunction = require("UIServerProgress/UIServerProgressViewFunction")
local Controller = require("UIActivityMain/BlackTeaActivityController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.InitData()
    Controller.RefreshServerStage()
    View.Group_TopLeft.Img_Server:SetSprite(GetResPath(88300028))
    View.Group_TopLeft.Btn_Personal:SetSprite(GetResPath(88300029))
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
