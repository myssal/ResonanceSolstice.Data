local View = require("UIIslandTip/UIIslandTipView")
local DataModel = require("UIIslandTip/UIIslandTipDataModel")
local CommonItem = require("Common/BtnItem")
local ViewFunction = {
  IslandTip_Btn__Click = function(btn, str)
  end,
  IslandTip_Btn_Open_Click = function(btn, str)
    UIManager:CloseSpecialUI(DataModel.activityCA.showOpenTipsUI)
    PlayerData:SetPlayerPrefs("int", "ActivityTip" .. DataModel.activityId .. DataModel.index, 1)
    UIManager:Open("UI/Activity/ActivityMain", Json.encode({
      id = DataModel.activityId
    }))
  end,
  IslandTip_Group_Preview_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.activityCA.rewardPreviewList[tonumber(elementIndex)]
    CommonItem:SetItem(element.Group_Item, row)
    element.Group_Item.Txt_Num:SetActive(row.isShowNum)
    element.Group_Item.Btn_Item:SetClickParam(row.id)
  end,
  IslandTip_Group_Preview_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    CommonTips.OpenPreRewardDetailTips(str)
  end
}
return ViewFunction
