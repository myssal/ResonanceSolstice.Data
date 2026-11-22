local View = require("UIChoseSkinTip/UIChoseSkinTipView")
local DataModel = require("UIChoseSkinTip/UIChoseSkinTipDataModel")
local ViewFunction = require("UIChoseSkinTip/UIChoseSkinTipViewFunction")
local ChoseSkinDataModel = require("UIChoseSkin/UIChoseSkinDataModel")
local Luabehaviour = {
  serialize = function()
  end,
  deserialize = function(initParams)
    local params = Json.decode(initParams)
    DataModel.SkinImg = params.img
    DataModel.ItemId = params.itemId
    DataModel.SkinCA = PlayerData:GetFactoryData(params.id)
    DataModel.Free = params.free
    DataModel.IsHave = params.isHave
    DataModel.Index = params.index
    local skinData = DataModel.SkinCA
    local skinItemType = PlayerData:GetFactoryData(params.itemId).chosekind
    if skinItemType == ChoseSkinDataModel.EnumSkinType.RoleSkin then
      View.Group_Txt.Txt_name:SetText(skinData.SkinName)
      View.Group_Show.Img_Gift:SetSprite(DataModel.SkinImg)
      View.Group_Txt.Txt_txt:SetText(skinData.SkinDesc)
      View.Group_Txt.Txt_tip:SetText(string.format(GetText(80607945), DataModel.Free))
    elseif skinItemType == ChoseSkinDataModel.EnumSkinType.CarSkin then
      View.Group_Txt.Txt_name:SetText(skinData.name)
      View.Group_Show.Img_Gift:SetSprite(DataModel.SkinImg)
      View.Group_Txt.Txt_txt:SetText(skinData.des)
      View.Group_Txt.Txt_tip:SetText(string.format(GetText(80610424), DataModel.Free))
    end
    View.Group_Txt.Txt_tip:SetActive(DataModel.IsHave)
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
