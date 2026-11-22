local View = require("UIMakeLvUp/UIMakeLvUpView")
local DataModel = require("UIMakeLvUp/UIMakeLvUpDataModel")
local ViewFunction = require("UIMakeLvUp/UIMakeLvUpViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    View.Img_TxtBg.Group_Txt.Txt_1:SetText("LV" .. data.oldLv)
    View.Img_TxtBg.Group_Txt.Txt_2:SetText("LV" .. data.nowLv)
    View.self:PlayAnim("MakeLvUp", function()
      UIManager:GoBack(false)
    end)
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
