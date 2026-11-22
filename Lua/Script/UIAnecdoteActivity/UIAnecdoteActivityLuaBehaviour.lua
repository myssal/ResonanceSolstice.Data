local View = require("UIAnecdoteActivity/UIAnecdoteActivityView")
local DataModel = require("UIAnecdoteActivity/UIAnecdoteActivityDataModel")
local ViewFunction = require("UIAnecdoteActivity/UIAnecdoteActivityViewFunction")
local nowX = -1
local nowY = -1
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    DataModel.Init()
    local cfg = PlayerData:GetFactoryData(DataModel.anecdoteData.characterId)
    local spinePath = PlayerData:GetFactoryData(cfg.viewId).gachaSpine2Url
    View.Group_Bg.SpineAnimation_Character2:SetData(spinePath)
    View.Group_Bg.SpineAnimation_Character2:SetPos(nowX + DataModel.anecdoteData.spineX, nowY + DataModel.anecdoteData.spineY)
    View.Group_Right.Txt_AnecdoteName:SetText(DataModel.anecdoteData.anecdoteName)
    View.Group_Right.Group_SubTitle.Txt_CharacterName:SetText(cfg.name)
    View.Group_Right.Txt_Brief:SetText(DataModel.anecdoteData.brief)
    View.Group_Right.Group_RewardPreview.Img_Keepsake:SetSprite(DataModel.tokenTipsPath)
    View.Group_Right.Group_RewardPreview.Txt_KeepsakeName:SetText(DataModel.tokenName)
    View.Group_Bg.SpineAnimation_Character2:SetActive(true)
    View.Group_Right.Img_Title:SetSprite(GetResPath(88300016))
  end,
  awake = function()
    nowX = View.Group_Bg.SpineAnimation_Character2:GetAnchoredPositionX()
    nowY = View.Group_Bg.SpineAnimation_Character2:GetAnchoredPositionY()
  end,
  start = function()
  end,
  update = function()
  end,
  ondestroy = function()
  end,
  enable = function()
    View.Group_Bg.SpineAnimation_Character2:SetActive(false)
  end,
  disenable = function()
    PlayerData:SetPlayerPrefs("int", DataModel.anecdoteData.id .. "Activity", 1)
    require("UIActivityMain/UIActivityMainView").Group_List.ScrollGrid_List.grid.self:RefreshAllElement()
  end
}
return {
  Luabehaviour,
  View,
  ViewFunction
}
