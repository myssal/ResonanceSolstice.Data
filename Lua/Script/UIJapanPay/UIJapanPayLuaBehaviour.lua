local View = require("UIJapanPay/UIJapanPayView")
local DataModel = require("UIJapanPay/UIJapanPayDataModel")
local ViewFunction = require("UIJapanPay/UIJapanPayViewFunction")
local ViewController = require("UIJapanPay/UIJapanPayViewController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    ViewController:DeserializeView(initParams)
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
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
