local View = require("UISettleAccount/UISettleAccountView")
local DataModel = require("UISettleAccount/UISettleAccountDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Reward_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local data = DataModel.reward[elementIndex]
    CommonItem:SetItem(element.Group_Item, {
      id = data.itemId,
      num = data.num
    })
    element.Group_Item.Btn_Item:SetClickParam(data.itemId)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Reward_ScrollGrid_Rewards_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Seal_Group_Seal_Btn__Click = function(btn, str)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Seal_StaticGrid_Seal_SetGrid = function(element, elementIndex)
    local witchesData = WitchData.GetWitchesData()
    local id = witchesData.user_seal[elementIndex]
    local itemCA = PlayerData:GetFactoryData(id, "ItemFactory")
    element.Img_Seal:SetSprite(itemCA.iconPath)
    element.Img_.Txt_:SetText(itemCA.name)
    element.Btn_:SetClickParam(id)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Seal_StaticGrid_Seal_Group_Seal_Btn__Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Guka_ScrollGrid_Guka_SetGrid = function(element, elementIndex)
    local data = DataModel.gukaList[elementIndex]
    local gukaCA = PlayerData:GetFactoryData(data.id, "GuKaFactory")
    element.Img_GuKaName.Txt_Name:SetText(gukaCA.name)
    element.Img_:SetSprite(gukaCA.iconPath)
    element.Btn_:SetClickParam(data.id)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Guka_ScrollGrid_Guka_Group_Item_Btn__Click = function(btn, str)
  end,
  SettleAccount_Group_Win_ScrollView__Viewport_Content_Group_Ticket_Img_Ticket_Btn__Click = function(btn, str)
  end,
  SettleAccount_Group_Lose_Group__Group_Reward_ScrollGrid_Rewards_SetGrid = function(element, elementIndex)
    local data = DataModel.reward[elementIndex]
    CommonItem:SetItem(element.Group_Item, {
      id = data.itemId,
      num = data.num
    })
    element.Group_Item.Btn_Item:SetClickParam(data.itemId)
  end,
  SettleAccount_Group_Lose_Group__Group_Reward_ScrollGrid_Rewards_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  SettleAccount_Group_Lose_Group__Btn_Confirm_Click = function(btn, str)
    View.self:CloseUI()
    local UIMainFinishDataModel = require("UIMainFinish/UIMainFinishDataModel")
    UIMainFinishDataModel.ReturnHome()
    WitchData.FinishClearData()
  end,
  SettleAccount_Group_Win_Btn_Confirm_Click = function(btn, str)
    View.self:CloseUI()
    local UIMainFinishDataModel = require("UIMainFinish/UIMainFinishDataModel")
    UIMainFinishDataModel.ReturnHome()
    WitchData.FinishClearData()
  end
}
return ViewFunction
