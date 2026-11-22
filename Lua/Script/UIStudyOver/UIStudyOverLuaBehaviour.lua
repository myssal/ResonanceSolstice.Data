local View = require("UIStudyOver/UIStudyOverView")
local DataModel = require("UIStudyOver/UIStudyOverDataModel")
local ViewFunction = require("UIStudyOver/UIStudyOverViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    local ca = PlayerData:GetFactoryData(params.id)
    local skinCA = PlayerData:GetFactoryData(ca.showPic)
    View.Group_gp.Txt_CarriageName:SetText(ca.name)
    View.Group_gp.Group_TrainSkin.Img_mengban.Img_Skin:SetSprite(skinCA.skinDisplay)
    View.Group_gp.Img_SkinType:SetSprite(skinCA.thumbnail)
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
