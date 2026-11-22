local CommonItem = require("Common/BtnItem")
local View = require("UIServerConstruction/UIServerConstructionView")
local DataModel = require("UIServerConstruction/UIServerConstructionDataModel")
local Controller = require("UIServerConstruction/UIServerConstructionController")
local ViewFunction = {
  ServerConstruction_Group_Right_ScrollGrid_ProgressList_SetGrid = function(element, elementIndex)
    Controller:SetGridElement(element, elementIndex)
  end,
  ServerConstruction_Group_Right_ScrollGrid_ProgressList_Group_Item_ScrollGrid_Reward_SetGrid = function(element, elementIndex)
    local row = DataModel.allStage[tonumber(element.ParentParam)]
    local rewardInfo = row.rewardList[elementIndex]
    if rewardInfo then
      CommonItem:SetItem(element.Group_Item, rewardInfo)
      element.Group_Item.Btn_Item:SetClickParam(rewardInfo.id)
    end
  end,
  ServerConstruction_Group_Right_ScrollGrid_ProgressList_Group_Item_ScrollGrid_Reward_Group_Item_Group_Item_Btn_Item_Click = function(btn, str)
    local itemId = tonumber(str)
    CommonTips.OpenPreRewardDetailTips(itemId)
  end,
  ServerConstruction_Group_Right_ScrollGrid_ProgressList_Group_Item_Btn__Click = function(btn, str)
    local row = DataModel.allStage[tonumber(str)]
    Controller:ClickReward(row)
  end,
  ServerConstruction_Group_CommonTopLeft_Btn_Return_Click = function(btn, str)
    UIManager:GoBack()
  end,
  ServerConstruction_Group_CommonTopLeft_Btn_Home_Click = function(btn, str)
    UIManager:GoHome()
  end,
  ServerConstruction_Group_CommonTopLeft_Btn_Menu_Click = function(btn, str)
  end,
  ServerConstruction_Group_CommonTopLeft_Btn_Help_Click = function(btn, str)
  end,
  ServerConstruction_Group_TopLeft_Group_All_Btn__Click = function(btn, str)
    DataModel.isAll = true
    Controller:Init()
  end,
  ServerConstruction_Group_TopLeft_Group_One_Btn__Click = function(btn, str)
    DataModel.isAll = false
    Controller:Init()
  end
}
return ViewFunction
