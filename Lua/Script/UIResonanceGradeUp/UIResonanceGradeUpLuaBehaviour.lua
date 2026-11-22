local View = require("UIResonanceGradeUp/UIResonanceGradeUpView")
local DataModel = require("UIResonanceGradeUp/UIResonanceGradeUpDataModel")
local ViewFunction = require("UIResonanceGradeUp/UIResonanceGradeUpViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    if initParams ~= nil then
      local params = Json.decode(initParams)
      View.Img_Icon:SetSprite(params.iconPath)
      View.Group_Up.Txt_UpBefore:SetText(params.level)
      View.Group_Up.Txt_UpLater:SetText(params.level + 1)
      View.ScrollView_Describe.Viewport.Txt_Describe:SetText(params.desc)
      View.Img_Icon.Img_skill:SetActive(params.isSkill)
    end
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
