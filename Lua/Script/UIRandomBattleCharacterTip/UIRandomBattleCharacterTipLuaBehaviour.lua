local View = require("UIRandomBattleCharacterTip/UIRandomBattleCharacterTipView")
local DataModel = require("UICharacterTips/UICharacterTipsDataModel")
local ViewFunction = require("UIRandomBattleCharacterTip/UIRandomBattleCharacterTipViewFunction")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel:SetUIScript("UIRandomBattleCharacterTip/UIRandomBattleCharacterTipView")
    local row = Json.decode(initParams)
    DataModel.RoleId = row.id
    DataModel.Type = row.type and row.type or 0
    DataModel.IsGoback = row.isGoback or false
    DataModel.IsBook = row.isBook or false
    if DataModel.IsBook and row.content then
      DataModel.BookRoleData = row.content
    end
    DataModel:SetSelectPos({
      [1] = -264,
      [2] = 0,
      [3] = 264
    })
    DataModel:SetSize(60, 136, 810, 980)
    DataModel:SetSpaceRight(30)
    DataModel:SetIsSetHeight(false)
    DataModel.live2D = true
    DataModel:Reset()
    DataModel:Clear()
    View.Group_CharacterSkin.ScrollView_Skin.Viewport.Content.Group_Spine.Spine_Head:SetActive(false)
    DataModel:SetRole(row.id, row.lv, row.awakeLv, row.resonanceLv, "UI/Activity/ActivityRandomBattle/Group_Skill", "UI/Activity/ActivityRandomBattle/Group_Resonance", "UI/Activity/ActivityRandomBattle/Group_Awake", row.equipList)
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
