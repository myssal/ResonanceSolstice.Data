local View = require("UITips_Witches/UITips_WitchesView")
local DataModel = require("UITips_Witches/UITips_WitchesDataModel")
local ViewFunction = require("UITips_Witches/UITips_WitchesViewFunction")
local count
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    View.Txt_Tips:SetText(data.content)
    count = 0
  end,
  awake = function()
  end,
  start = function()
  end,
  perupdate = function()
  end,
  update = function()
    count = count + 1
    if 90 < count then
      View.self:CloseUI()
    end
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
