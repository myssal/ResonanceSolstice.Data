local View = require("UIKoreaAcountInfo/UIKoreaAcountInfoView")
local DataModel = require("UIKoreaAcountInfo/UIKoreaAcountInfoDataModel")
local ViewFunction = require("UIKoreaAcountInfo/UIKoreaAcountInfoViewFunction")
local ViewController = require("UIKoreaAcountInfo/UIKoreaAcountInfoViewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
  end,
  awake = function()
    ViewController:InitView()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
    ViewController:DestroyView()
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
