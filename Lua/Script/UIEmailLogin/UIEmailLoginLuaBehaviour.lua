local View = require("UIEmailLogin/UIEmailLoginView")
local DataModel = require("UIEmailLogin/UIEmailLoginDataModel")
local ViewFunction = require("UIEmailLogin/UIEmailLoginViewFunction")
local ViewController = require("UIEmailLogin/UIEmailLoginViewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ViewController:DeserializeView()
    View.Group_NewLoginAndJoin.Img_BG.Img_BG.Img_Logo:SetSprite(GetResPath(88300030))
    View.Group_NewLoginAndJoin.Img_BG.Img_BG2.Img_Logo:SetSprite(GetResPath(88300030))
  end,
  awake = function()
    ViewController:AwakeView()
  end,
  start = function()
  end,
  update = function()
    ViewController:UpdateView()
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
