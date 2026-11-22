local View = require("UIGroup_KabaneriLevelFirstOpen/UIGroup_KabaneriLevelFirstOpenView")
local DataModel = require("UIGroup_KabaneriLevelFirstOpen/UIGroup_KabaneriLevelFirstOpenDataModel")
local ViewFunction = require("UIGroup_KabaneriLevelFirstOpen/UIGroup_KabaneriLevelFirstOpenViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    View.Img_OpenNameBg.Img_OpenName:SetSprite(GetResPath(88300098))
    PlayerData:SetPlayerPrefs("int", "KabaneriLevelFirstOpen", 1)
    View.self:PlayAnimOnce("Open", function()
      View.self:CloseUI()
      UIManager:Open("UI/Activity/Kabaneri/KabaneriLevel")
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
