local View = require("UICubeRogueHpTips/UICubeRogueHpTipsView")
local DataModel = require("UICubeRogueHpTips/UICubeRogueHpTipsDataModel")
local ViewFunction = require("UICubeRogueHpTips/UICubeRogueHpTipsViewFunction")
local Controller = require("UICubeRogueHpTips/UICubeRogueHpTipsController")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local data = Json.decode(initParams)
    View.Group_Lose:SetActive(not data.isAdd)
    View.Group_Recover:SetActive(data.isAdd)
    View.Group_Lose.Img_Title:SetSprite(GetResPath(88300210))
    View.Group_Recover.Img_Title:SetSprite(GetResPath(88300209))
    View.self:PlayAnim("enter", function()
      UIManager:GoBack(false)
      local rogueMain = require("UICubeRogueMain/UICubeRoguewMainController")
      if UIManager:IsPanelOpened("UI/CubeRogue/Main/CubeRogueMain") then
        rogueMain.OnPanelBack()
      elseif rogueMain.TryShowReward() then
      end
    end)
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
